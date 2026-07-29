#!/bin/bash

is_numeric() {
    [[ "$1" =~ ^-?[0-9]+(\.[0-9]+)?$ ]]
}

while true; do
    echo "------------------------------------------"
    read -p "Enter first variable (userv1): " userv1
    read -p "Enter second variable (userv2): " userv2
    echo "------------------------------------------"

    # Addition
    if is_numeric "$userv1" && is_numeric "$userv2"; then
        sum=$(echo "$userv1 + $userv2" | bc -l)
        echo "the sum of '$userv1' and '$userv2' is $sum"
    else
        echo "Error: Cannot perform addition because one or both variables are non-numeric."
    fi

    # Multiplication
    if is_numeric "$userv1" && is_numeric "$userv2"; then
        prod=$(echo "$userv1 * $userv2" | bc -l)
        echo "the product of '$userv1' and '$userv2' is $prod"
    else
        echo "Error: Cannot perform multiplication because one or both variables are non-numeric."
    fi

    # Subtraction
    if is_numeric "$userv1" && is_numeric "$userv2"; then
        diff=$(echo "$userv1 - $userv2" | bc -l)
        echo "the difference of '$userv1' and '$userv2' is $diff"
    else
        echo "Error: Cannot perform subtraction because one or both variables are non-numeric."
    fi

    # Division
    if is_numeric "$userv1" && is_numeric "$userv2"; then
        # Check for division by zero
        if (( $(echo "$userv2 == 0" | bc -l) )); then
            echo "Error: Cannot perform division because division by zero is undefined."
        else
            div=$(echo "$userv1 / $userv2" | bc -l)
            echo "the division of '$userv1' by '$userv2' is $div"
        fi
    else
        echo "Error: Cannot perform division because one or both variables are non-numeric."
    fi

    # Printing in reverse order
    echo "the variables in reverse order are '$userv2' and '$userv1'"

    echo "------------------------------------------"
    read -p "Do you want to run again? (y/n): " choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        echo "Exiting program. Goodbye!"
        break
    fi
    echo
done