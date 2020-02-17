## Find occupier process
`ps -e | grep OCCUPIED_NAME`

## Fix unexpected termination of last 'apt get upgrade'
`sudo dpkg --configure -a`
