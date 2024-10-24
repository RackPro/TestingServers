# Параметры для запуска 
# SEQ - запускает тесты последовательно
# CPU - запускает stress-ng, затем sysbench для CPU
# RAM - запускает stress-ng, sysbench для RAM
# DSK - запускает sysbench для дисковой подсистемы
# PG -
# ALL - запускает тестирование по компонентам парралельно

#Дериктория куда будут сохраняться логи. $(pwd) - 
pwd=$(pwd)

#Включенные тесты
stress_ng="false"   #инструмент для создания нагрузки на систем.
sysbench="true"    #инструмент для созданя сравнительных показателей. 

# Создание файла для результатов
cpu_test_results="cpu_test_results.txt"
vmstat_cpu_test_results="vmstat_cpu_test_results.txt" #Вывод во время stress
mem_test_results="mem_test_results.txt"
vmstat_mem_test_results="vmstat_mem_test_results.txt" #Вывод во время stress
file_test_results="file_test_results.txt"
resultDir="/logs-$1-$(date +"(%H:%M)-(%d|%m|%Y)")"

#Конфигурирование vmstat
vmstat_v="false" # Выводить vmstat или нет. "false" - отключить вывод
vmstat_interval=1 # -w : Устанавливает интервал вывода n секунд. "false" - отключить параметр
vmstat_conclusion=15 # Указывает, сколько раз должна быть выведена статистика. n раз.
vmstat_time="true" # Добавляет временные метки в вывод vmstat. "false" - отключить параметр

# --------------------------------Параметры тестирования CPU----------------------------
# stress-ng
duration_cpu=60         #Продолжительность теста в секундах. "false" - отключить параметр
num_threads=$(nproc)    #Количество доступных процессорных ядер (все - $(nproc)). "false" - отключить параметр
cpu_statistics=true     #Включает более подробный вывод статистики. "false" - отключить параметр
cpu_method=false        #Устанавливает метод загрузки CPU. Доступные методы:                        "false" - отключить параметр
# all ackermann apery bitops callfunc cdouble cfloat clongdouble collatz correlate crc16 dither div8 div16 
# div32 div64 div128 double euler explog factorial fibonacci fft fletcher16 float floatconversion gamma 
# gcd gray hamming hanoi hyperbolic idct int128 int64 int32 int16 int8 int128float int128double int128longdouble 
# int64float int64double int64longdouble int32float int32double int32longdouble intconversion ipv4checksum jmp 
# lfsr32 ln2 logmap longdouble loop matrixprod nsqrt omega parity phi pi prime psi queens rand rand48 rgb sieve 
# stats sqrt trig union zeta
cpu_load=false          #Устанавливает загрузку CPU в процентах. Например - 40. По умолчанию 100. "false" - по умолчанию

# sysbench
prime_limit=20000       #Максимальное простое число для тестирования (увеличить для более интенсивной нагрузки)
s_num_threads=$(nproc)  #Количество доступных процессорных ядер (все - $(nproc))
sb_cpu_events=false     #Устанавливает количество событий, которые будут обработаны в тесте. "false" - отключить параметр
sb_cpu_time=false       #Устанавливает продолжительность теста в секундах.
sb_cpu_report=false     #Устанавливает интервал вывода статистики в секундах. По умолчанию - каждую секунду. "false" - По умолчанию


# --------------------------------Параметры тестирования RAM----------------------------
# stress-ng
ng_ram_time=30      # -t : Устанавливает длительность теста в секундах. "false" - отключить параметр
ng_ram_interval=1   # -i : Устанавливает интервал вывода статистики в секундах. По умолчанию статистика выводится каждую секунду. "false" - отключить параметр
ng_ram_report=true  # -v :Включает более подробный вывод статистики. "false" - отключить параметр
ng_ram_vm=1         # --vm : Загружает виртуальную память количеством_операций создания/уничтожения страниц в секунду.
ng_ram_method=all   # --vm-method : Устанавливает метод загрузки виртуальной памяти. "false" - отключить параметр
# all cache-lines cache-stripe checkerboard flip fwdrev galpat-0 galpat-1 gray grayflip 
# rowhammer incdec inc-nybble lfsr32 rand-set rand-sum read64 ror swap move-inv modulo-x 
# mscan wrrd128nt prime-0 prime-1 prime-gray-0 prime-gray-1 prime-incdec walk-0d walk-1d 
# walk-0a walk-1a write64 write64nt write1024v zero-one
ng_ram_bytes=4K     # --vm-bytes : Устанавливает размер блоков памяти для выделения и освобождения в байтах. По умолчанию - 4 КБ. "false" - по умолчанию
ng_ram_vmmax=false  # --vm-max : Устанавливает максимальный размер блока памяти для выделения в байтах. По умолчанию - не ограничен. "false" - по умолчанию

# sysbench
sb_memory_block_size=4K     # --memory-block-size : размер блока памяти для тестирования. По умолчанию 1КБ. "false" - по умолчанию
sb_memory_total_size=50G    # --memory-total-size : общий объем передаваемых данных. По умолчанию 100G. "false" - по умолчанию
sb_memory_scope=global      # --memory-scope : область доступа к строковой памяти. По умолчанию global. "false" - по умолчанию. Параметры: global, local
sb_memory_hugetlb=off       # --memory-hugetlb : выделять память из пула HugeTLB. По умолчанию выключено. "false" - по умолчанию. Параметры: on, off
sb_memory_oper=read         # --memory-oper : строковый тип операций с памятью. По умолчанию запись. "false" - по умолчанию. Параметры: read, write, none
sb_memory_access_mode=seq   # --memory-access-mode : режим доступа к памяти. По умолчанию seq. "false" - по умолчанию. Параметры: seq, rnd.

# ----------------------------Параметры тестирования производительности дисков----------------------------
# sysbench
sb_fileio_file_num=128          # --file-num : Количество файлов для создания. По умолчанию 128. "false" - по умолчанию
sb_fileio_block_size=16384      # --file-block-size : Размер блока, который будет использоваться во всех операциях ввода-вывода. По умолчанию 16384. "false" - по умолчанию
sb_fileio_total_size=2G         # --file-total-size : Общий размер файлов для создания. По умолчанию 2G. "false" - по умолчанию
sb_fileio_test_mode=seqwr       # --file-test-mode : Cтроковый тестовый режим.  {seqwr, seqrewr, seqrd, rndrd, rndwr, rndrw}. Обязательный параметр
sb_fileio_io_mode=sync          # --file-io-mode : Режим работы со строковыми файлами {sync,async,mmap}. По умолчанию sync. "false" - по умолчанию.
sb_fileio_async_backlog=128     # --file-async-backlog : N количество асинхронных операций в очереди для каждого потока. По умолчанию 128. "false" - по умолчанию.
sb_fileio_extra_flags=false     # --file-extra-flags=[LIST,...] : Cписок дополнительных флагов, используемых для открытия файлов. {sync,dsync,direct}. По умолчанию []. "false" - по умолчанию.
sb_fileio_fsync_freq=100        # --file-fsync-freq : N выполнять fsync() после указанного количества запросов (0 - не использовать fsync()). По умолчанию 100. "false" - по умолчанию.
sb_fileio_file_fsync_all=off    # --file-fsync-all : Выполняет fsync() после каждой операции записи. По умолчанию off. "false" - по умолчанию. Параметры - off, on.
sb_fileio_file_fsync_end=on     # --file-fsync-end : выполняет fsync() в конце теста [вкл.] По умолчанию on. "false" - по умолчанию. Параметры - off, on.
sb_fileio_fsync_mode=fsync      # --file-fsync-mode : Какой метод использовать для синхронизации. По умолчанию fsync. "false" - по умолчанию. Параметры - fsync, fdatasync.
sb_fileio_merged_requests=0     # --file-merged-requests : Возможности объединить не более этого количества запросов ввода-вывода По умолчанию (0 - не объединять). "false" - по умолчанию.
sb_fileio_rw_ratio=1.5          # --file-rw-ratio : N коэффициентов чтения/записи для комбинированного теста По умолчанию 1.5 . "false" - по умолчанию.

# ----------------------------Параметры тестирования PG----------------------------
pg_host=localhost # -h : Устанавливает имя хоста базы данных PostgreSQL (по умолчанию: localhost).
pg_port=5432 # -p : Устанавливает номер порта базы данных PostgreSQL (по умолчанию: 5432).
pg_user=false # -U : Устанавливает имя пользователя базы данных (по умолчанию: текущий пользователь). false - по умолчанию.
pg_debag=false # -d : вывод на печать отладочных данных.
pg_clients=2 # -n : Устанавливает количество клиентов, которые будут симулироваться в тесте.
pg_transactions=2 # -c : Устанавливает количество транзакций, которые будет выполнять каждый клиент.
pg_time=60 # -T : Устанавливает время выполнения теста в секундах.
