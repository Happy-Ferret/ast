########################################################################
#                                                                      #
#               This software is part of the ast package               #
#          Copyright (c) 1982-2013 AT&T Intellectual Property          #
#                      and is licensed under the                       #
#                 Eclipse Public License, Version 1.0                  #
#                    by AT&T Intellectual Property                     #
#                                                                      #
#                A copy of the License is available at                 #
#          http://www.eclipse.org/org/documents/epl-v10.html           #
#         (with md5 checksum b35adb5213ca9657e911e9befb180842)         #
#                                                                      #
#              Information and Software Systems Research               #
#                            AT&T Research                             #
#                           Florham Park NJ                            #
#                                                                      #
#                    David Korn <dgkorn@gmail.com>                     #
#                                                                      #
########################################################################

typeset -T Pt_t=(
    float x=1
    float y=0
    len()
    {
        print -r $((sqrt(_.x*_.x + _.y*_.y)))
    }
)

for ((i=0; i < 100; i++))
do
    Pt_t p
    [[ ${p.x} == 1 ]] || log_error '${p[x]} is not 1'
    (( p.x == 1 )) || err_ext 'p[x] is not 1'
    [[ $(p.len) == 1 ]] || log_error '$(p.len) != 1'
    [[ ${p.len} == 1 ]] || log_error '${p.len} != 1'
    (( p.len == 1  )) || log_error '((p.len != 1))'
    Pt_t q=(y=2)
    (( q.x == 1 )) || log_error 'q.x is not 1'
    (( (q.len - sqrt(5)) < 10e-10 )) || log_error 'q.len != sqrt(5)'
    q.len()
    {
        print -r $((abs(_.x)+abs(_.y) ))
    }
    (( q.len == 3 )) || log_error 'q.len is not 3'
    p=q
    [[ ${p.y} == 2 ]] || log_error '${p[y]} is not 2'
    [[ ${@p} == Pt_t ]] || log_error 'type of p is not Pt_t'
    [[ ${@q} == Pt_t ]] || log_error 'type of q is not Pt_t'
    (( p.len == 3 )) || log_error 'p.len is not 3'
    unset p q
    Pt_t pp=( (  x=3 y=4) (  x=5 y=12) (y=2) )
    (( pp[0].len == 5 )) || log_error 'pp[0].len != 5'
    (( pp[1].len == 13 )) || log_error 'pp[0].len != 12'
    (( (pp[2].len - sqrt(5)) < 10e-10 )) || log_error 'pp[2].len != sqrt(5)'
    [[ ${pp[1]} == $'(\n\ttypeset -l -E x=5\n\ttypeset -l -E y=12\n)' ]] || log_error '${pp[1] is not correct'
    [[ ${!pp[@]} == '0 1 2' ]] || log_error '${pp[@] != "0 1 2"'
    pp+=( x=6 y=8)
    (( pp[3].len == 10 )) || log_error 'pp[3].len != 10'
    [[ ${!pp[@]} == '0 1 2 3' ]] || log_error '${pp[@] != "0 1 2 3"'
    pp[4]=pp[1]
    [[ ${pp[4]} == $'(\n\ttypeset -l -E x=5\n\ttypeset -l -E y=12\n)' ]] || log_error '${pp[4] is not correct'
    unset pp
    Pt_t pp=( [one]=(  x=3 y=4) [two]=(  x=5 y=12) [three]=(y=2) )
    (( pp[one].len == 5 )) || log_error 'pp[one].len != 5'
    (( pp[two].len == 13 )) || log_error 'pp[two].len != 12'
    [[ ${pp[two]} == $'(\n\ttypeset -l -E x=5\n\ttypeset -l -E y=12\n)' ]] || log_error '${pp[two] is not correct'
    [[ ${!pp[@]} == 'one three two' ]] || log_error '${pp[@] != "one three two"'
    [[ ${@pp[1]} == Pt_t ]] || log_error 'type of pp[1] is not Pt_t'
    unset pp
done

unset pt
Pt_t -a pt=( (x=3 y=4) (x=5 y=7) (x=1 y=9) (x=0 y=11))
set -s -Apt -Kx:n
exp='Pt_t -a pt=((typeset -l -E x=0;typeset -l -E y=11) (typeset -l -E x=1;typeset -l -E y=9) (typeset -l -E x=3;typeset -l -E y=4) (typeset -l -E x=5;typeset -l -E y=7))'
[[ $(typeset -p pt) == "$exp" ]] || log_error 'sorting of points not working'
set -s -Apt -Kx:rn
exp='Pt_t -a pt=((typeset -l -E x=5;typeset -l -E y=7) (typeset -l -E x=3;typeset -l -E y=4) (typeset -l -E x=1;typeset -l -E y=9) (typeset -l -E x=0;typeset -l -E y=11))'
[[ $(typeset -p pt) == "$exp" ]] || log_error 'reverse sorting of points not working'

# redefinition of point
typeset -T Pt_t=(
    Pt_t _=(x=3 y=6)
    float z=2
    len()
    {
        print -r $((sqrt(_.x*_.x + _.y*_.y + _.z*_.z)))
    }
)
Pt_t p
[[ ${p.y} == 6 ]] || log_error '${p.y} != 6'
(( p.len == 7 )) || log_error '((p.len !=7))'

z=()
Pt_t -a z.p
z.p[1]=(y=2)
z.p[2]=(y=5)
z.p[3]=(x=6 y=4)
eval y="$z"
[[ $y == "$z" ]] || log_error 'expansion of indexed array of types is incorrect'
eval "$(typeset -p y)"
[[ $y == "$z" ]] || log_error 'typeset -p z for indexed array of types is incorrect'
unset z y
z=()
Pt_t -A z.p
z.p[1]=(y=2)
z.p[2]=(y=5)
z.p[3]=(x=6 y=4)
eval y="$z"
[[ $y == "$z" ]] || log_error 'expansion of associative array of types is incorrect'
eval "$(typeset -p y)"
[[ $y == "$z" ]] || log_error 'typeset -p z for associative of types is incorrect'
unset z y

typeset -T A_t=(
        Pt_t  -a  b
)
typeset -T B_t=(
        Pt_t  -A  b
)
A_t r
r.b[1]=(y=2)
r.b[2]=(y=5)
eval s="$r"
[[ $r == "$s" ]] || log_error 'expansion of type containing index array of types is incorrect'
eval "$(typeset -p s)"
[[ $y == "$z" ]] || log_error 'typeset -p z for type containing index of types is incorrect'
unset r s
B_t r
r.b[1]=(y=2)
r.b[2]=(y=5)
eval s="$r"
[[ $r == "$s" ]] || log_error 'expansion of type containing index array of types is incorrect'
eval "$(typeset -p s)"
[[ $y == "$z" ]] || log_error 'typeset -p z for type containing index of types is incorrect'
