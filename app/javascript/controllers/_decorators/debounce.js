/**
 * The debounce pattern delays the calling of the event handler until a pause happens.
 * This technique is commonly used in search boxes with a suggest drop-down list.
 * By applying this pattern, we can prevent unnecessary requests to the backend while the user is typing.
 *
 * Example:
 *
 * @debounce(500)
 * def search(event) {
 *     ...
 * }
 *
 * @param ms milliseconds to wait new function call
 * @returns {Function}
 */
export default function debounce(ms) {
    let debounceTimeoutId;

    return (target, property, descriptor) => {
        const originalMethod = descriptor.value;

        descriptor.value = function(...args) {
            clearTimeout(debounceTimeoutId);
            debounceTimeoutId = setTimeout(() => originalMethod.apply(this, args), ms);
        }
    }
}