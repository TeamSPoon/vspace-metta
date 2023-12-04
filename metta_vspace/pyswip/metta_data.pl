
metta_impl(['type-cast', Atom, Type, Space], [fn, [chain, [eval, ['get-metatype', Atom]], Meta, [eval, ['if-equal', Type, Meta, [return, Atom], [chain, [eval, ['collapse-get-type', Atom, Space]], Actual_types, [chain, [eval, ['foldl-atom', Actual_types, 'False', A, B, [chain, [eval, ['match-types', B, Type, 'True', 'False']], Is_b_comp, [chain, [eval, [or, A, Is_b_comp]], Or, Or]]]], Is_some_comp, [eval, [if, Is_some_comp, [return, Atom], [return, ['Error', Atom, 'BadType']]]]]]]]]]).
metta_impl(['type-cast', Atom, Type, Space], [chain, [eval, ['get-type', Atom, Space]], Actual_type, [eval, [switch, [Actual_type, Type], [[['%Undefined%', _], Atom], [[_, '%Undefined%'], Atom], [[Type, _], Atom], [_, ['Error', Atom, 'BadType']]]]]]).
metta_impl(['switch-internal', Atom, [[Pattern, Template], Tail]], [match, Atom, Pattern, Template, [eval, [switch, Atom, Tail]]]).
metta_impl(['switch-internal', Atom, [[Pattern, Template], Tail]], [fn, [unify, Atom, Pattern, [return, Template], [chain, [eval, [switch, Atom, Tail]], Ret, [return, Ret]]]]).
metta_impl([switch, Atom, Cases], [fn, [chain, [decons, Cases], List, [chain, [eval, ['switch-internal', Atom, List]], Res, [chain, [eval, ['if-not-reducible', Res, 'Empty', Res]], X, [return, X]]]]]).
metta_impl([switch, Atom, Cases], [chain, [decons, Cases], List, [eval, ['switch-internal', Atom, List]]]).
metta_impl([subst, Atom, Var, Templ], [match, Atom, Var, Templ, ['Error', [subst, Atom, Var, Templ], 'subst expects a variable as a second argument']]).
metta_impl(['return-on-error', Atom, Then], [fn, [eval, ['if-empty', Atom, [return, [return, 'Empty']], [eval, ['if-error', Atom, [return, [return, Atom]], [return, Then]]]]]]).
metta_impl(['return-on-error', Atom, Then], [eval, ['if-empty', Atom, 'Empty', [eval, ['if-error', Atom, Atom, Then]]]]).
metta_impl([reduce, Atom, Var, Templ], [chain, [eval, Atom], Res, [eval, ['if-error', Res, Res, [eval, ['if-empty', Res, [eval, [subst, Atom, Var, Templ]], [eval, [reduce, Res, Var, Templ]]]]]]]).
metta_impl(['metta-call', Atom, Type, Space], [fn, [eval, ['if-error', Atom, [return, Atom], [chain, [eval, Atom], Result, [eval, ['if-not-reducible', Result, [return, Atom], [eval, ['if-empty', Result, [return, 'Empty'], [eval, ['if-error', Result, [return, Result], [chain, [eval, [interpret, Result, Type, Space]], Ret, [return, Ret]]]]]]]]]]]]).
metta_impl(['match-types', Type1, Type2, Then, Else], [fn, [eval, ['if-equal', Type1, '%Undefined%', [return, Then], [eval, ['if-equal', Type2, '%Undefined%', [return, Then], [eval, ['if-equal', Type1, 'Atom', [return, Then], [eval, ['if-equal', Type2, 'Atom', [return, Then], [unify, Type1, Type2, [return, Then], [return, Else]]]]]]]]]]]).
metta_impl([match, Space, Pattern, Template], [unify, Pattern, Space, Template, 'Empty']).
metta_impl(['map-atom', List, Var, Map], [fn, [eval, ['if-decons', List, Head, Tail, [chain, [eval, ['map-atom', Tail, Var, Map]], Tail_mapped, [chain, [eval, [apply, Head, Var, Map]], Map_expr, [chain, Map_expr, Head_mapped, [chain, [cons, Head_mapped, Tail_mapped], Res, [return, Res]]]]], [return, []]]]]).
metta_impl([let, Pattern, Atom, Template], [unify, Atom, Pattern, Template, 'Empty']).
metta_impl(['let*', Pairs, Template], [eval, ['if-decons', Pairs, [Pattern, Atom], Tail, [let, Pattern, Atom, ['let*', Tail, Template]], Template]]).
metta_impl(['is-function', Type], [fn, [chain, [eval, ['get-metatype', Type]], Meta, [eval, [switch, [Type, Meta], [[[_, 'Expression'], [eval, ['if-decons', Type, Head, _tail, [unify, Head, ->, [return, 'True'], [return, 'False']], [return, ['Error', ['is-function', Type], 'is-function non-empty expression as an argument']]]]], [_, [return, 'False']]]]]]]).
metta_impl(['is-function', Type], [chain, [eval, ['get-metatype', Type]], Meta, [eval, [switch, [Type, Meta], [[[_, 'Expression'], [chain, [eval, [car, Type]], Head, [match, Head, ->, 'True', 'False']]], [_, 'False']]]]]).
metta_impl(['interpret-tuple', Atom, Space], [match, Atom, [], Atom, [eval, ['if-decons', Atom, Head, Tail, [chain, [eval, [interpret, Head, '%Undefined%', Space]], Rhead, [chain, [eval, ['interpret-tuple', Tail, Space]], Rtail, [cons, Rhead, Rtail]]], ['Error', ['interpret-tuple', Atom, Space], 'Non-empty expression atom is expected as an argument']]]]).
metta_impl(['interpret-tuple', Atom, Space], [fn, [unify, Atom, [], [return, Atom], [eval, ['if-decons', Atom, Head, Tail, [chain, [eval, [interpret, Head, '%Undefined%', Space]], Rhead, [eval, ['if-empty', Rhead, [return, 'Empty'], [chain, [eval, ['interpret-tuple', Tail, Space]], Rtail, [eval, ['if-empty', Rtail, [return, 'Empty'], [chain, [cons, Rhead, Rtail], Ret, [return, Ret]]]]]]]], [return, ['Error', ['interpret-tuple', Atom, Space], 'Non-empty expression atom is expected as an argument']]]]]]).
metta_impl(['interpret-func', Expr, Type, Space], [eval, ['if-decons', Expr, Op, Args, [chain, [eval, [interpret, Op, Type, Space]], Reduced_op, [eval, ['return-on-error', Reduced_op, [eval, ['if-decons', Type, Arrow, Arg_types, [chain, [eval, ['interpret-args', Expr, Args, Arg_types, Space]], Reduced_args, [eval, ['return-on-error', Reduced_args, [cons, Reduced_op, Reduced_args]]]], ['Error', Type, 'Function type expected']]]]]], ['Error', Expr, 'Non-empty expression atom is expected']]]).
metta_impl(['interpret-func', Expr, Type, Ret_type, Space], [fn, [eval, ['if-decons', Expr, Op, Args, [chain, [eval, [interpret, Op, Type, Space]], Reduced_op, [eval, ['return-on-error', Reduced_op, [eval, ['if-decons', Type, Arrow, Arg_types, [chain, [eval, ['interpret-args', Expr, Args, Arg_types, Ret_type, Space]], Reduced_args, [eval, ['return-on-error', Reduced_args, [chain, [cons, Reduced_op, Reduced_args], R, [return, R]]]]], [return, ['Error', Type, 'Function type expected']]]]]]], [return, ['Error', Expr, 'Non-empty expression atom is expected']]]]]).
metta_impl(['interpret-expression', Atom, Type, Space], [fn, [eval, ['if-decons', Atom, Op, Args, [chain, [eval, ['get-type', Op, Space]], Op_type, [chain, [eval, ['is-function', Op_type]], Is_func, [unify, Is_func, 'True', [chain, [eval, ['interpret-func', Atom, Op_type, Type, Space]], Reduced_atom, [chain, [eval, ['metta-call', Reduced_atom, Type, Space]], Ret, [return, Ret]]], [chain, [eval, ['interpret-tuple', Atom, Space]], Reduced_atom, [chain, [eval, ['metta-call', Reduced_atom, Type, Space]], Ret, [return, Ret]]]]]], [chain, [eval, ['type-cast', Atom, Type, Space]], Ret, [return, Ret]]]]]).
metta_impl(['interpret-expression', Atom, Type, Space], [eval, ['if-decons', Atom, Op, Args, [chain, [eval, ['get-type', Op, Space]], Op_type, [chain, [eval, ['is-function', Op_type]], Is_func, [match, Is_func, 'True', [chain, [eval, ['interpret-func', Atom, Op_type, Space]], Reduced_atom, [eval, [call, Reduced_atom, Type, Space]]], [chain, [eval, ['interpret-tuple', Atom, Space]], Reduced_atom, [eval, [call, Reduced_atom, Type, Space]]]]]], [eval, ['type-cast', Atom, Type, Space]]]]).
metta_impl(['interpret-args-tail', Atom, Head, Args_tail, Args_tail_types, Space], [chain, [eval, ['interpret-args', Atom, Args_tail, Args_tail_types, Space]], Reduced_tail, [eval, ['return-on-error', Reduced_tail, [cons, Head, Reduced_tail]]]]).
metta_impl(['interpret-args-tail', Atom, Head, Args_tail, Args_tail_types, Ret_type, Space], [fn, [chain, [eval, ['interpret-args', Atom, Args_tail, Args_tail_types, Ret_type, Space]], Reduced_tail, [eval, ['return-on-error', Reduced_tail, [chain, [cons, Head, Reduced_tail], Ret, [return, Ret]]]]]]).
metta_impl(['interpret-args', Atom, Args, Arg_types, Space], [match, Args, [], [match, Arg_types, [Ret], [], ['Error', Atom, 'BadType']], [eval, ['if-decons', Args, Head, Tail, [eval, ['if-decons', Arg_types, Head_type, Tail_types, [chain, [eval, [interpret, Head, Head_type, Space]], Reduced_head, [eval, ['if-equal', Reduced_head, Head, [eval, ['interpret-args-tail', Atom, Reduced_head, Tail, Tail_types, Space]], [eval, ['return-on-error', Reduced_head, [eval, ['interpret-args-tail', Atom, Reduced_head, Tail, Tail_types, Space]]]]]]], ['Error', Atom, 'BadType']]], ['Error', ['interpret-atom', Atom, Args, Arg_types, Space], 'Non-empty expression atom is expected']]]]).
metta_impl(['interpret-args', Atom, Args, Arg_types, Ret_type, Space], [fn, [unify, Args, [], [eval, ['if-decons', Arg_types, Actual_ret_type, _tail, [eval, ['match-types', Actual_ret_type, Ret_type, [return, []], [return, ['Error', Atom, 'BadType']]]], [return, ['Error', ['interpret-args', Atom, Args, Arg_types, Ret_type, Space], 'interpret-args expects a non-empty value for $arg-types argument']]]], [eval, ['if-decons', Args, Head, Tail, [eval, ['if-decons', Arg_types, Head_type, Tail_types, [chain, [eval, [interpret, Head, Head_type, Space]], Reduced_head, [eval, ['if-equal', Reduced_head, Head, [chain, [eval, ['interpret-args-tail', Atom, Reduced_head, Tail, Tail_types, Ret_type, Space]], Ret, [return, Ret]], [eval, ['return-on-error', Reduced_head, [chain, [eval, ['interpret-args-tail', Atom, Reduced_head, Tail, Tail_types, Ret_type, Space]], Ret, [return, Ret]]]]]]], [return, ['Error', Atom, 'BadType']]]], [return, ['Error', ['interpret-atom', Atom, Args, Arg_types, Space], 'Non-empty expression atom is expected']]]]]]).
metta_impl([interpret, Atom, Type, Space], [fn, [chain, [eval, ['get-metatype', Atom]], Meta, [eval, ['if-equal', Type, 'Atom', [return, Atom], [eval, ['if-equal', Type, Meta, [return, Atom], [eval, [switch, [Type, Meta], [[[_type, 'Variable'], [return, Atom]], [[_type, 'Symbol'], [chain, [eval, ['type-cast', Atom, Type, Space]], Ret, [return, Ret]]], [[_type, 'Grounded'], [chain, [eval, ['type-cast', Atom, Type, Space]], Ret, [return, Ret]]], [[_type, 'Expression'], [chain, [eval, ['interpret-expression', Atom, Type, Space]], Ret, [return, Ret]]]]]]]]]]]]).
metta_impl([interpret, Atom, Type, Space], [chain, [eval, ['get-metatype', Atom]], Meta, [eval, [switch, [Type, Meta], [[['Atom', _meta], Atom], [[Meta, Meta], Atom], [[_type, 'Variable'], Atom], [[_type, 'Symbol'], [eval, ['type-cast', Atom, Type, Space]]], [[_type, 'Grounded'], [eval, ['type-cast', Atom, Type, Space]]], [[_type, 'Expression'], [eval, ['interpret-expression', Atom, Type, Space]]]]]]]).
metta_impl(['if-not-reducible', Atom, Then, Else], [fn, [eval, ['if-equal', Atom, 'NotReducible', [return, Then], [return, Else]]]]).
metta_impl(['if-non-empty-expression', Atom, Then, Else], [fn, [chain, [eval, ['get-metatype', Atom]], Type, [eval, ['if-equal', Type, 'Expression', [eval, ['if-equal', Atom, [], [return, Else], [return, Then]]], [return, Else]]]]]).
metta_impl(['if-non-empty-expression', Atom, Then, Else], [chain, [eval, ['get-metatype', Atom]], Type, [eval, ['if-equal', Type, 'Expression', [eval, ['if-equal', Atom, [], Else, Then]], Else]]]).
metta_impl(['if-error', Atom, Then, Else], [fn, [eval, ['if-decons', Atom, Head, _, [eval, ['if-equal', Head, 'Error', [return, Then], [return, Else]]], [return, Else]]]]).
metta_impl(['if-error', Atom, Then, Else], [eval, ['if-decons', Atom, Head, _, [eval, ['if-equal', Head, 'Error', Then, Else]], Else]]).
metta_impl(['if-empty', Atom, Then, Else], [fn, [eval, ['if-equal', Atom, 'Empty', [return, Then], [return, Else]]]]).
metta_impl(['if-empty', Atom, Then, Else], [eval, ['if-equal', Atom, 'Empty', Then, Else]]).
metta_impl(['if-decons', Atom, Head, Tail, Then, Else], [fn, [eval, ['if-non-empty-expression', Atom, [chain, [decons, Atom], List, [unify, List, [Head, Tail], [return, Then], [return, Else]]], [return, Else]]]]).
metta_impl(['if-decons', Atom, Head, Tail, Then, Else], [eval, ['if-non-empty-expression', Atom, [chain, [decons, Atom], List, [match, List, [Head, Tail], Then, Else]], Else]]).
metta_impl(['foldl-atom', List, Init, A, B, Op], [fn, [eval, ['if-decons', List, Head, Tail, [chain, [eval, [apply, Init, A, Op]], Op_init, [chain, [eval, [apply, Head, B, Op_init]], Op_head, [chain, Op_head, Head_folded, [chain, [eval, ['foldl-atom', Tail, Head_folded, A, B, Op]], Res, [return, Res]]]]], [return, Init]]]]).
metta_impl(['filter-atom', List, Var, Filter], [fn, [eval, ['if-decons', List, Head, Tail, [chain, [eval, ['filter-atom', Tail, Var, Filter]], Tail_filtered, [chain, [eval, [apply, Head, Var, Filter]], Filter_expr, [chain, Filter_expr, Is_filtered, [eval, [if, Is_filtered, [chain, [cons, Head, Tail_filtered], Res, [return, Res]], [return, Tail_filtered]]]]]], [return, []]]]]).
metta_impl(['cdr-atom', Atom], [eval, ['if-decons', Atom, _, Tail, Tail, ['Error', ['cdr-atom', Atom], 'cdr-atom expects a non-empty expression as an argument']]]).
metta_impl(['car-atom', Atom], [eval, ['if-decons', Atom, Head, _, Head, ['Error', ['car-atom', Atom], 'car-atom expects a non-empty expression as an argument']]]).
metta_impl([car, Atom], [eval, ['if-decons', Atom, Head, _, Head, ['Error', [car, Atom], 'car expects a non-empty expression as an argument']]]).
metta_impl([call, Atom, Type, Space], [chain, [eval, Atom], Result, [eval, ['if-empty', Result, Atom, [eval, ['if-error', Result, Result, [eval, [interpret, Result, Type, Space]]]]]]]).
metta_impl([apply, Atom, Var, Templ], [fn, [chain, [eval, [id, Atom]], Var, [return, Templ]]]).
metta_impl([and, 'True', 'True'], 'True').
metta_impl([and, 'True', 'False'], 'False').
metta_impl([and, 'False', 'True'], 'False').
metta_impl([and, 'False', 'False'], 'False').
metta_impl([or, 'True', 'True'], 'True').
metta_impl([or, 'True', 'False'], 'True').
metta_impl([or, 'False', 'True'], 'True').
metta_impl([or, 'False', 'False'], 'False').
metta_impl([unquote, [quote, Atom]], Atom).
metta_impl([quote, Atom], 'NotReducible').
metta_impl([nop], []).
metta_impl([nop, X], []).
metta_impl([if, 'True', Then, Else], Then).
metta_impl([if, 'False', Then, Else], Else).
metta_impl([id, X], X).


% Comparison Operators in Prolog
is_comp_op('=', 2).          % Unification
is_comp_op('\\=', 2).        % Not unifiable
is_comp_op('==', 2).         % Strict equality
is_comp_op('\\==', 2).       % Strict inequality
is_comp_op('@<', 2).         % Term is before
is_comp_op('@=<', 2).        % Term is before or equal
is_comp_op('@>', 2).         % Term is after
is_comp_op('@>=', 2).        % Term is after or equal
is_comp_op('=<', 2).         % Less than or equal
is_comp_op('<', 2).          % Less than
is_comp_op('>=', 2).         % Greater than or equal
is_comp_op('>', 2).          % Greater than
is_comp_op('is', 2).         % Arithmetic equality
is_comp_op('=:=', 2).        % Arithmetic exact equality
is_comp_op('=\\=', 2).       % Arithmetic inequality

% Arithmetic Operations
is_math_op('*', 2, exists).         % Multiplication
is_math_op('**', 2, exists).        % Exponentiation
is_math_op('+', 1, exists).         % Unary Plus
is_math_op('+', 2, exists).         % Addition
is_math_op('-', 1, exists).         % Unary Minus
is_math_op('-', 2, exists).         % Subtraction
is_math_op('.', 2, exists).         % Array Indexing or Member Access (Depends on Context)
is_math_op('/', 2, exists).         % Division
is_math_op('//', 2, exists).        % Floor Division
is_math_op('///', 2, exists).       % Alternative Division Operator (Language Specific)
is_math_op('/\\', 2, exists).       % Bitwise AND
is_math_op('<<', 2, exists).        % Bitwise Left Shift
is_math_op('>>', 2, exists).        % Bitwise Right Shift
is_math_op('\\', 1, exists).        % Bitwise NOT
is_math_op('\\/', 2, exists).       % Bitwise OR
is_math_op('^', 2, exists).         % Bitwise XOR
is_math_op('abs', 1, exists).       % Absolute Value
is_math_op('acos', 1, exists).      % Arc Cosine
is_math_op('acosh', 1, exists).     % Hyperbolic Arc Cosine
is_math_op('asin', 1, exists).      % Arc Sine
is_math_op('asinh', 1, exists).     % Hyperbolic Arc Sine
is_math_op('atan', 1, exists).      % Arc Tangent
is_math_op('atan2', 2, exists).     % Two-Argument Arc Tangent
is_math_op('atanh', 1, exists).     % Hyperbolic Arc Tangent
is_math_op('cbrt', 1, exists).      % Cube Root
is_math_op('ceil', 1, exists).      % Ceiling Function
is_math_op('ceiling', 1, exists).   % Ceiling Value
is_math_op('cmpr', 2, exists).      % Compare Two Values (Language Specific)
is_math_op('copysign', 2, exists).  % Copy the Sign of a Number
is_math_op('cos', 1, exists).       % Cosine Function
is_math_op('cosh', 1, exists).      % Hyperbolic Cosine
is_math_op('cputime', 0, exists).   % CPU Time
is_math_op('degrees', 1, exists).   % Convert Radians to Degrees
is_math_op('denominator', 1, exists). % Get Denominator of Rational Number
is_math_op('div', 2, exists).       % Integer Division
is_math_op('e', 0, exists).         % Euler's Number
is_math_op('epsilon', 0, exists).   % Machine Epsilon
is_math_op('erf', 1, exists).       % Error Function
is_math_op('erfc', 1, exists).      % Complementary Error Function
is_math_op('eval', 1, exists).      % Evaluate Expression
is_math_op('exp', 1, exists).       % Exponential Function
is_math_op('expm1', 1, exists).     % exp(x) - 1
is_math_op('fabs', 1, exists).      % Absolute Value (Floating-Point)
is_math_op('float', 1, exists).     % Convert Rational to Float
is_math_op('float_fractional_part', 1, exists). % Fractional Part of Float
is_math_op('float_integer_part', 1, exists).    % Integer Part of Float
is_math_op('floor', 1, exists).     % Floor Value
is_math_op('fmod', 2, exists).      % Floating-Point Modulo Operation
is_math_op('frexp', 2, exists).     % Get Mantissa and Exponent
is_math_op('fsum', 1, exists).      % Accurate Floating Point Sum
is_math_op('gamma', 1, exists).     % Gamma Function
is_math_op('gcd', 2, exists).       % Greatest Common Divisor
is_math_op('getbit', 2, exists).    % Get Bit at Position
is_math_op('hypot', 2, exists).     % Euclidean Norm, Square Root of Sum of Squares
is_math_op('inf', 0, exists).       % Positive Infinity
is_math_op('integer', 1, exists).   % Convert Float to Integer
is_math_op('isinf', 1, exists).     % Check for Infinity
is_math_op('isnan', 1, exists).     % Check for Not a Number
is_math_op('lcm', 2, exists).       % Least Common Multiple
is_math_op('ldexp', 2, exists).     % Load Exponent of a Floating Point Number
is_math_op('lgamma', 1, exists).    % Log Gamma
is_math_op('log', 1, exists).       % Logarithm Base e
is_math_op('log10', 1, exists).     % Base 10 Logarithm
is_math_op('log1p', 1, exists).     % log(1 + x)
is_math_op('log2', 1, exists).      % Base 2 Logarithm
is_math_op('lsb', 1, exists).       % Least Significant Bit
is_math_op('max', 2, exists).       % Maximum of Two Values
is_math_op('maxr', 2, exists).      % Maximum Rational Number (Language Specific)
is_math_op('min', 2, exists).       % Minimum of Two Values
is_math_op('minr', 2, exists).      % Minimum Rational Number (Language Specific)
is_math_op('mod', 2, exists).       % Modulo Operation
is_math_op('modf', 2, exists).      % Return Fractional and Integer Parts
is_math_op('msb', 1, exists).       % Most Significant Bit
is_math_op('nan', 0, exists).       % Not a Number
is_math_op('nexttoward', 2, exists). % Next Representable Floating-Point Value
is_math_op('numerator', 1, exists). % Get Numerator of Rational Number
is_math_op('pi', 0, exists).        % Pi
is_math_op('popcount', 1, exists).  % Count of Set Bits
is_math_op('pow', 2, exists).       % Exponentiation
is_math_op('powm', 3, exists).      % Modulo Exponentiation
is_math_op('radians', 1, exists).   % Convert Degrees to Radians
is_math_op('remainder', 2, exists). % Floating-Point Remainder
is_math_op('remquo', 3, exists).    % Remainder and Part of Quotient
is_math_op('round', 1, exists).     % Round to Nearest Integer
is_math_op('roundeven', 1, exists). % Round to Nearest Even Integer
is_math_op('setbit', 2, exists).    % Set Bit at Position
is_math_op('signbit', 1, exists).   % Sign Bit of Number
is_math_op('sin', 1, exists).       % Sine Function
is_math_op('sinh', 1, exists).      % Hyperbolic Sine
is_math_op('sqrt', 1, exists).      % Square Root
is_math_op('tan', 1, exists).       % Tangent Function
is_math_op('tanh', 1, exists).      % Hyperbolic Tangent
is_math_op('testbit', 2, exists).   % Test Bit at Position
is_math_op('trunc', 1, exists).     % Truncate Decimal to Integer
is_math_op('ulogb', 1, exists).     % Unbiased Exponent of a Floating-Point Value
is_math_op('xor', 2, exists).       % Exclusive OR
is_math_op('zerop', 1, exists).     % Test for Zero



end_of_file.



% # 1. Length of a List
% %  Normal Recursive
% prolog
len([], 0).
len([_|T], N) :-
    len(T, X),
    N is X + 1.
%

% %  With Accumulator
% prolog
len_acc(L, N) :-
    len_acc(L, 0, N).

len_acc([], Acc, Acc).
len_acc([_|T], Acc, N) :-
    NewAcc is Acc + 1,
    len_acc(T, NewAcc, N).
%

% # 2. Sum of a List
% %  Normal Recursive
% prolog
sum([], 0).
sum([H|T], S) :-
    sum(T, X),
    S is X + H.
%

% %  With Accumulator
% prolog
sum_acc(L, S) :-
    sum_acc(L, 0, S).

sum_acc([], Acc, Acc).
sum_acc([H|T], Acc, S) :-
    NewAcc is Acc + H,
    sum_acc(T, NewAcc, S).
%

% # 3. Factorial
% %  Normal Recursive
% prolog
factorial(0, 1).
factorial(N, F) :-
    N > 0,
    X is N - 1,
    factorial(X, Y),
    F is N * Y.
%

% %  With Accumulator
% prolog
factorial_acc(N, F) :-
    factorial_acc(N, 1, F).

factorial_acc(0, Acc, Acc).
factorial_acc(N, Acc, F) :-
    N > 0,
    NewAcc is Acc * N,
    NewN is N - 1,
    factorial_acc(NewN, NewAcc, F).
%

% # 4. Reverse List
% %  Normal Recursive
% prolog
reverse_list([], []).
reverse_list([H|T], R) :-
    reverse_list(T, RevT),
    append(RevT, [H], R).
%

% %  With Accumulator
% prolog
reverse_list_acc(L, R) :-
    reverse_list_acc(L, [], R).

reverse_list_acc([], Acc, Acc).
reverse_list_acc([H|T], Acc, R) :-
    reverse_list_acc(T, [H|Acc], R).
%

% # 5. Fibonacci
% %  Normal Recursive
% prolog
fibonacci(0, 0).
fibonacci(1, 1).
fibonacci(N, F) :-
    N > 1,
    N1 is N - 1,
    N2 is N - 2,
    fibonacci(N1, F1),
    fibonacci(N2, F2),
    F is F1 + F2.
%

% %  With Accumulator
% prolog
fibonacci_acc(N, F) :-
    fibonacci_acc(N, 0, 1, F).

fibonacci_acc(0, A, _, A).
fibonacci_acc(N, A, B, F) :-
    N > 0,
    NewN is N - 1,
    NewB is A + B,
    fibonacci_acc(NewN, B, NewB, F).
%



%  6. Find an Element in a List
% # Normal Recursive
% prolog
element_in_list(X, [X|_]).
element_in_list(X, [_|T]) :- element_in_list(X, T).
%

% # With Accumulator
% prolog
element_in_list_acc(X, L) :- element_in_list_acc(X, L, false).

element_in_list_acc(X, [], Acc) :- Acc.
element_in_list_acc(X, [X|_], _) :- true.
element_in_list_acc(X, [_|T], Acc) :- element_in_list_acc(X, T, Acc).
%

%  7. Check if a List is a Palindrome
% # Normal Recursive
% prolog
is_palindrome(L) :- reverse(L, L).
%

% # With Accumulator
% prolog
is_palindrome_acc(L) :- reverse_acc(L, [], L).

reverse_acc([], Acc, Acc).
reverse_acc([H|T], Acc, R) :- reverse_acc(T, [H|Acc], R).
%

%  8. Calculate the Product of All Elements in a List
% # Normal Recursive
% prolog
product_list([], 1).
product_list([H|T], P) :-
    product_list(T, Temp),
    P is H * Temp.
%

% # With Accumulator
% prolog
product_list_acc(L, P) :- product_list_acc(L, 1, P).

product_list_acc([], Acc, Acc).
product_list_acc([H|T], Acc, P) :-
    NewAcc is Acc * H,
    product_list_acc(T, NewAcc, P).
%

%  9. Find the Nth Element of a List
% # Normal Recursive
% prolog
nth_element(1, [H|_], H).
nth_element(N, [_|T], X) :-
    N > 1,
    M is N - 1,
    nth_element(M, T, X).
%

% # With Accumulator
% prolog
nth_element_acc(N, L, X) :- nth_element_acc(N, L, 1, X).

nth_element_acc(N, [H|_], N, H).
nth_element_acc(N, [_|T], Acc, X) :-
    NewAcc is Acc + 1,
    nth_element_acc(N, T, NewAcc, X).
%

%  10. Count the Occurrences of an Element in a List
% # Normal Recursive
% prolog
count_occurrences(_, [], 0).
count_occurrences(X, [X|T], N) :-
    count_occurrences(X, T, M),
    N is M + 1.
count_occurrences(X, [Y|T], N) :-
    X \= Y,
    count_occurrences(X, T, N).
%

% # With Accumulator
% prolog
count_occurrences_acc(X, L, N) :- count_occurrences_acc(X, L, 0, N).

count_occurrences_acc(_, [], Acc, Acc).
count_occurrences_acc(X, [X|T], Acc, N) :-
    NewAcc is Acc + 1,
    count_occurrences_acc(X, T, NewAcc, N).
count_occurrences_acc(X, [Y|T], Acc, N) :-
    X \= Y,
    count_occurrences_acc(X, T, Acc, N).
%

%  11. Calculate the Greatest Common Divisor of Two Numbers
% # Normal Recursive
% prolog
gcd(A, 0, A) :- A > 0.
gcd(A, B, GCD) :-
    B > 0,
    R is A mod B,
    gcd(B, R, GCD).
%

% # With Accumulator
% prolog
gcd_acc(A, B, GCD) :- gcd_acc(A, B, 1, GCD).

gcd_acc(A, 0, Acc, Acc) :- A > 0.
gcd_acc(A, B, Acc, GCD) :-
    B > 0,
    R is A mod B,
    NewAcc is B * Acc,
    gcd_acc(B, R, NewAcc, GCD).
%

%  12. Check if a Number is Prime
% # Normal Recursive
% prolog
is_prime(2).
is_prime(N) :-
    N > 2,
    \+ (between(2, sqrt(N), X), N mod X =:= 0).
%

% # With Accumulator
% prolog
is_prime_acc(N) :- is_prime_acc(N, 2).

is_prime_acc(2, 2).
is_prime_acc(N, Acc) :-
    N > 2,
    (
        (Acc * Acc > N, !);
        (N mod Acc =\= 0, NewAcc is Acc + 1, is_prime_acc(N, NewAcc))
    ).
%

%  13. Merge Two Sorted Lists into a Sorted List
% # Normal Recursive
% prolog
merge_sorted([], L, L).
merge_sorted(L, [], L).
merge_sorted([H1|T1], [H2|T2], [H1|M]) :-
    H1 =< H2,
    merge_sorted(T1, [H2|T2], M).
merge_sorted([H1|T1], [H2|T2], [H2|M]) :-
    H1 > H2,
    merge_sorted([H1|T1], T2, M).
%

% # With Accumulator
% prolog
merge_sorted_acc(L1, L2, L) :- merge_sorted_acc(L1, L2, [], L).

merge_sorted_acc([], L, Acc, L) :- reverse(Acc, L), !.
merge_sorted_acc(L, [], Acc, L) :- reverse(Acc, L), !.
merge_sorted_acc([H1|T1], [H2|T2], Acc, [H|M]) :-
    H1 =< H2,
    merge_sorted_acc(T1, [H2|T2], [H1|Acc], M).
merge_sorted_acc([H1|T1], [H2|T2], Acc, [H|M]) :-
    H1 > H2,
    merge_sorted_acc([H1|T1], T2, [H2|Acc], M).

%

%  14. Find the Last Element of a List
% # Normal Recursive
% prolog
last_element([H], H).
last_element([_|T], X) :- last_element(T, X).
%

% # With Accumulator
% prolog
last_element_acc([H|T], X) :- last_element_acc(T, H, X).

last_element_acc([], Acc, Acc).
last_element_acc([H|T], _, X) :- last_element_acc(T, H, X).
%

%  15. Remove Duplicate Elements from a List
% # Normal Recursive
% prolog
remove_duplicates([], []).
remove_duplicates([H|T], [H|T1]) :- \+ member(H, T), remove_duplicates(T, T1).
remove_duplicates([_|T], T1) :- remove_duplicates(T, T1).
%

% # With Accumulator
% prolog
remove_duplicates_acc(L, R) :- remove_duplicates_acc(L, [], R).

remove_duplicates_acc([], Acc, Acc).
remove_duplicates_acc([H|T], Acc, R) :-
    (member(H, Acc) -> remove_duplicates_acc(T, Acc, R);
    remove_duplicates_acc(T, [H|Acc], R)).
%

%  16. Check if a Binary Tree is Balanced
% # Normal Recursive
% prolog
is_balanced(null).
is_balanced(tree(L, _, R)) :-
    height(L, Hl),
    height(R, Hr),
    D is Hl - Hr,
    abs(D) =< 1,
    is_balanced(L),
    is_balanced(R).
%

% # With Accumulator
% prolog
is_balanced_acc(T) :- is_balanced_acc(T, 0).

is_balanced_acc(null, 0).
is_balanced_acc(tree(L, _, R), H) :-
    is_balanced_acc(L, Hl),
    is_balanced_acc(R, Hr),
    D is Hl - Hr,
    abs(D) =< 1,
    H is max(Hl, Hr) + 1.
%

%  17. Calculate the Height of a Binary Tree
% # Normal Recursive
% prolog
height(null, 0).
height(tree(L, _, R), H) :-
    height(L, Hl),
    height(R, Hr),
    H is max(Hl, Hr) + 1.
%

% # With Accumulator
% prolog
height_acc(T, H) :- height_acc(T, 0, H).

height_acc(null, Acc, Acc).
height_acc(tree(L, _, R), Acc, H) :-
    NewAcc is Acc + 1,
    height_acc(L, NewAcc, Hl),
    height_acc(R, NewAcc, Hr),
    H is max(Hl, Hr).
%

%  18. Search for an Element in a Binary Search Tree
% # Normal Recursive
% prolog
search_bst(tree(_, X, _), X).
search_bst(tree(L, Y, _), X) :-
    X < Y,
    search_bst(L, X).
search_bst(tree(_, Y, R), X) :-
    X > Y,
    search_bst(R, X).
%

% # With Accumulator
% prolog
% The accumulator is not very useful here, as the search path is already determined by the BST property.
search_bst_acc(Tree, X) :- search_bst(Tree, X).
%

%  19. Insert an Element into a Binary Search Tree
% # Normal Recursive
% prolog
insert_bst(null, X, tree(null, X, null)).
insert_bst(tree(L, Y, R), X, tree(L1, Y, R)) :-
    X < Y,
    insert_bst(L, X, L1).
insert_bst(tree(L, Y, R), X, tree(L, Y, R1)) :-
    X > Y,
    insert_bst(R, X, R1).
%

% # With Accumulator
% prolog
% The accumulator is not very useful here, as the insertion path is already determined by the BST property.
insert_bst_acc(Tree, X, NewTree) :- insert_bst(Tree, X, NewTree).
%

%  20. Delete an Element from a Binary Search Tree
% # Normal Recursive
% prolog
delete_bst(Tree, X, NewTree) :-
    remove_bst(Tree, X, NewTree).

remove_bst(tree(L, X, R), X, Merged) :- merge_trees(L, R, Merged), !.
remove_bst(tree(L, Y, R), X, tree(L1, Y, R)) :-
    X < Y,
    remove_bst(L, X, L1).
remove_bst(tree(L, Y, R), X, tree(L, Y, R1)) :-
    X > Y,
    remove_bst(R, X, R1).

merge_trees(null, Tree, Tree).
merge_trees(Tree, null, Tree).
merge_trees(tree(L1, X, R1), tree(L2, Y, R2), tree(Merged, Y, R2)) :-
    merge_trees(tree(L1, X, R1), L2, Merged).
%

% # With Accumulator
% prolog
% The accumulator is not very useful here, as the deletion path is already determined by the BST property.
delete_bst_acc(Tree, X, NewTree) :- delete_bst(Tree, X, NewTree).
%

%  21. Find the Lowest Common Ancestor in a Binary Search Tree
% # Normal Recursive
% prolog
lowest_common_ancestor(tree(_, Y, _), X, Z, Y) :-
    X < Y, Z > Y;
    X > Y, Z < Y.
lowest_common_ancestor(tree(L, Y, _), X, Z, LCA) :-
    X < Y, Z < Y,
    lowest_common_ancestor(L, X, Z, LCA).
lowest_common_ancestor(tree(_, Y, R), X, Z, LCA) :-
    X > Y, Z > Y,


    lowest_common_ancestor(R, X, Z, LCA).
%

% # With Accumulator
% prolog
% The accumulator is not very useful here, as the search path is already determined by the BST property.
lowest_common_ancestor_acc(Tree, X, Z, LCA) :- lowest_common_ancestor(Tree, X, Z, LCA).
%

%  22. Check if a Graph is Cyclic
% For graphs, it's better to represent them in a Prolog-friendly format, such as adjacency lists. I will use a representation where each node has a list of its neighbors.
% # Normal Recursive
% prolog
is_cyclic(Graph) :-
    member(Vertex-_, Graph),
    dfs(Vertex, Graph, [Vertex], _), !.

dfs(Vertex, Graph, Visited, [Vertex|Visited]) :-
    member(Vertex-Neighbors, Graph),
    member(Neighbor, Neighbors),
    member(Neighbor, Visited), !.
dfs(Vertex, Graph, Visited, FinalVisited) :-
    member(Vertex-Neighbors, Graph),
    member(Neighbor, Neighbors),
    \+ member(Neighbor, Visited),
    dfs(Neighbor, Graph, [Neighbor|Visited], FinalVisited).
%

% # With Accumulator
% prolog
% Due to the way depth-first search works, a typical accumulator wouldn't be very effective.
% The visited list already acts like an accumulator.
is_cyclic_acc(Graph) :- is_cyclic(Graph).
%

%  23. Perform a Depth-First Search on a Graph
% # Normal Recursive
% prolog
dfs_graph(Vertex, Graph) :- dfs_vertex(Vertex, Graph, []).

dfs_vertex(Vertex, _, Visited) :- member(Vertex, Visited), !.
dfs_vertex(Vertex, Graph, Visited) :-
    write(Vertex), nl,
    member(Vertex-Neighbors, Graph),
    dfs_neighbors(Neighbors, Graph, [Vertex|Visited]).

dfs_neighbors([], _, _).
dfs_neighbors([Neighbor|Neighbors], Graph, Visited) :-
    dfs_vertex(Neighbor, Graph, Visited),
    dfs_neighbors(Neighbors, Graph, Visited).
%

% # With Accumulator
% prolog
% The visited list acts as an accumulator.
dfs_graph_acc(Vertex, Graph) :- dfs_graph(Vertex, Graph).
%

%  24. Perform a Breadth-First Search on a Graph
% # Normal Recursive
% prolog
bfs_graph(Vertex, Graph) :-
    bfs([Vertex], Graph, [Vertex]).

bfs([], _, _).
bfs([Vertex|Vertices], Graph, Visited) :-
    write(Vertex), nl,
    member(Vertex-Neighbors, Graph),
    filter_unvisited(Neighbors, Visited, NewNeighbors, NewVisited),
    append(Vertices, NewNeighbors, NewVertices),
    bfs(NewVertices, Graph, NewVisited).

filter_unvisited([], Visited, [], Visited).
filter_unvisited([Neighbor|Neighbors], Visited, NewNeighbors, NewVisited) :-
    (member(Neighbor, Visited) ->
        filter_unvisited(Neighbors, Visited, NewNeighbors, NewVisited);
        filter_unvisited(Neighbors, [Neighbor|Visited], NewNeighbors, [Neighbor|NewVisited])
    ).
%

% # With Accumulator
% prolog
% The visited list acts as an accumulator.
bfs_graph_acc(Vertex, Graph) :- bfs_graph(Vertex, Graph).
%

%  25. Check if a Graph is Connected
% # Normal Recursive
% prolog
is_connected(Graph) :-
    Graph = [Vertex-_|_],
    dfs_graph(Vertex, Graph),
    \+ (member(OtherVertex-_, Graph), \+ member(OtherVertex, Visited)), !.
%

% # With Accumulator
% prolog
% The visited list acts as an accumulator.
is_connected_acc(Graph) :- is_connected(Graph).
%

%  26. Find the Shortest Path between Two Nodes in a Graph
% # Normal Recursive
% prolog
shortest_path(Start, End, Graph, Path) :-
    shortest_path([Start], End, Graph, [Start], Path).

shortest_path(_, End, _, Visited, ReversePath) :-
    reverse(ReversePath, [End|_]), !.
shortest_path(Vertices, End, Graph, Visited, Path) :-
    adjacent_unvisited(Vertices, Graph, Visited, Adjacent),
    append(Visited, Adjacent, NewVisited),
    append(Vertices, Adjacent, NewVertices),
    shortest_path(NewVertices, End, Graph, NewVisited, Path).
%

% # With Accumulator
% prolog
% The visited list and the list of vertices to explore act as accumulators.
shortest_path_acc(Start, End, Graph, Path) :- shortest_path(Start, End, Graph, Path).
%

%  27. Check if a String is a Palindrome
% # Normal Recursive
% prolog
is_string_palindrome(Str) :- string_chars(Str, Chars), is_palindrome(Chars).
%

% # With Accumulator
% prolog
is_string_pal

indrome_acc(Str) :- string_chars(Str, Chars), is_palindrome_acc(Chars, []).
%

%  28. Compute the Edit Distance between Two Strings
% # Normal Recursive
% prolog
edit_distance([], [], 0).
edit_distance([_|T1], [], D) :-
    edit_distance(T1, [], D1),
    D is D1 + 1.
edit_distance([], [_|T2], D) :-
    edit_distance([], T2, D1),
    D is D1 + 1.
edit_distance([H1|T1], [H2|T2], D) :-
    edit_distance(T1, T2, D1),
    D is D1 + (H1 \= H2).
%

% # With Accumulator
% prolog
edit_distance_acc(S1, S2, D) :- edit_distance_acc(S1, S2, 0, D).

edit_distance_acc([], [], Acc, Acc).
edit_distance_acc([_|T1], [], Acc, D) :- NewAcc is Acc + 1, edit_distance_acc(T1, [], NewAcc, D).
edit_distance_acc([], [_|T2], Acc, D) :- NewAcc is Acc + 1, edit_distance_acc([], T2, NewAcc, D).
edit_distance_acc([H1|T1], [H2|T2], Acc, D) :-
    NewAcc is Acc + (H1 \= H2),
    edit_distance_acc(T1, T2, NewAcc, D).
%

%  29. Find the Longest Common Subsequence of Two Strings
% # Normal Recursive
% prolog
lcs([], _, []).
lcs(_, [], []).
lcs([H|T1], [H|T2], [H|Lcs]) :- lcs(T1, T2, Lcs), !.
lcs(S1, [_|T2], Lcs) :- lcs(S1, T2, Lcs).
lcs([_|T1], S2, Lcs) :- lcs(T1, S2, Lcs).
%

% # With Accumulator
% prolog
lcs_acc(S1, S2, Lcs) :- lcs_acc(S1, S2, [], Lcs).

lcs_acc([], _, Acc, Lcs) :- reverse(Acc, Lcs).
lcs_acc(_, [], Acc, Lcs) :- reverse(Acc, Lcs).
lcs_acc([H|T1], [H|T2], Acc, Lcs) :- lcs_acc(T1, T2, [H|Acc], Lcs).
lcs_acc(S1, [_|T2], Acc, Lcs) :- lcs_acc(S1, T2, Acc, Lcs).
lcs_acc([_|T1], S2, Acc, Lcs) :- lcs_acc(T1, S2, Acc, Lcs).
%

%  30. Find the Longest Common Substring of Two Strings
% # Normal Recursive
% prolog
longest_common_substring(S1, S2, Lcs) :-
    findall(Sub, (substring(S1, Sub), substring(S2, Sub)), Subs),
    longest_string(Subs, Lcs).

substring(Str, Sub) :-
    append(_, Rest, Str),
    append(Sub, _, Rest).

longest_string([H|T], Longest) :-
    longest_string(T, H, Longest).

longest_string([], Acc, Acc).
longest_string([H|T], Acc, Longest) :-
    length(H, LenH),
    length(Acc, LenAcc),
    (LenH > LenAcc -> longest_string(T, H, Longest); longest_string(T, Acc, Longest)).
%

% # With Accumulator
% prolog
longest_common_substring_acc(S1, S2, Lcs) :-
    findall(Sub, (substring(S1, Sub), substring(S2, Sub)), Subs),
    longest_string_acc(Subs, [], Lcs).

longest_string_acc([], Acc, Acc).
longest_string_acc([H|T], Acc, Longest) :-
    length(H, LenH),
    length(Acc, LenAcc),
    (LenH > LenAcc -> longest_string_acc(T, H, Longest); longest_string_acc(T, Acc, Longest)).
%


