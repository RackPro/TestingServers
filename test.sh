source config.sh

mkdir -p "$pwd/results/$resultDir"
cd "$pwd/results/$resultDir"
#---------------------------------------------CPU------------------------------------------------
if [[ $1 = "CPU" || $1 = "SEQ" ]]; then
    # Запись заголовка в файл
    echo "## Тестирование CPU" >> $cpu_test_results
    echo "Параметры:" >> $cpu_test_results
    echo "- Продолжительность: $duration_cpu секунд" >> $cpu_test_results
    echo "- Количество потоков: $num_threads" >> $cpu_test_results
    echo "- Максимальное простое число: $prime_limit" >> $cpu_test_results
    echo "" >> $cpu_test_results

    # Тест CPU
    echo "Тестирование CPU..." >> $cpu_test_results
    if [[ "$stress_ng" = "true" ]]; then
        echo "---Тестирование stress-ng---" >> $cpu_test_results

        p_vmstat="vmstat"
        if [[ "$vmstat_interval" != "false" ]]; then
            p_vmstat="$p_vmstat -w $vmstat_interval"
        fi
        if [[ "$vmstat_conclusion" != "false" ]]; then
            p_vmstat="$p_vmstat $vmstat_conclusion"
        fi
        if [[ "$vmstat_time" != "false" ]]; then
            p_vmstat="$p_vmstat -t"
        fi

        p_stress_ng="stress-ng"
        if [[ "$num_threads" != "false" ]]; then
            p_stress_ng="$p_stress_ng -c $num_threads"
        fi
        if [[ "$duration_cpu" != "false" ]]; then
            p_stress_ng="$p_stress_ng -t $duration_cpu"
        fi
        if [[ "$cpu_statistics" != "false" ]]; then
            p_stress_ng="$p_stress_ng -v"
        fi
        if [[ "$cpu_method" != "false" ]]; then
            p_stress_ng="$p_stress_ng --cpu-method $cpu_method"
        fi
        if [[ "$cpu_load" != "false" ]]; then
            p_stress_ng="$p_stress_ng --cpu-load $cpu_load"
        fi

        if [[ "$vmstat_v" != "false" ]]; then
            eval "$p_vmstat" >> $vmstat_cpu_test_results &
        fi
        
        eval "$p_stress_ng" >> $cpu_test_results
    fi
    if [[ "$sysbench" = "true" ]]; then
        echo "---Тестирование sysbench---" >> $cpu_test_results
        p_stress_ng="sysbench cpu"
        if [[ "$s_num_threads" != "false" ]]; then
            p_stress_ng="$p_stress_ng --threads=$s_num_threads"
        fi
        if [[ "$prime_limit" != "false" ]]; then
            p_stress_ng="$p_stress_ng --cpu-max-prime=$prime_limit"
        fi
        if [[ "$sb_cpu_events" != "false" ]]; then
            p_stress_ng="$p_stress_ng --events=$sb_cpu_events"
        fi
        if [[ "$sb_cpu_time" != "false" ]]; then
            p_stress_ng="$p_stress_ng --time=$sb_cpu_time"
        fi
        if [[ "$sb_cpu_report" != "false" ]]; then
            p_stress_ng="$p_stress_ng --report-interval=$sb_cpu_report"
        fi
        p_stress_ng="$p_stress_ng run"
        eval "$p_stress_ng" >> $cpu_test_results
    fi

    # Сбор дополнительной информации
    echo "" >> $cpu_test_results
    echo "Дополнительная информация:" >> $cpu_test_results
    echo "Дата и время тестирования: $(date)" >> $cpu_test_results
    echo "Количество ядер: $num_threads" >> $cpu_test_results

    if [[ "$1" = "CPU" && $(pgrep htop) ]]; then
        pkill htop
    fi
fi
#---------------------------------------------RAM----------------------------------------------
if [[ "$1" = "RAM" || "$1" = "SEQ" ]]; then
    # Запись заголовка в файл
    echo "## Тестирование RAM" > $mem_test_results
    echo "Параметры:" >> $mem_test_results
    echo "- Продолжительность: $duration_mem секунд" >> $mem_test_results
    echo "- Количество созданых виртуальных процессов: $num_vm" >> $mem_test_results
    echo "- Выделенная память для виртуального процесса: $vm_bytes" >> $mem_test_results
    echo "" >> $mem_test_results

    # Тест MEM
    echo "Тестирование ОЗУ..." >> $mem_test_results
    if [[ "$stress_ng" = "true" ]]; then
        echo "---Тестирование stress---" >> $mem_test_results
        p_vmstat="vmstat"
        if [[ "$vmstat_interval" != "false" ]]; then
            p_vmstat="$p_vmstat -w $vmstat_interval"
        fi
        if [[ "$vmstat_conclusion" != "false" ]]; then
            p_vmstat="$p_vmstat $vmstat_conclusion"
        fi
        if [[ "$vmstat_time" != "false" ]]; then
            p_vmstat="$p_vmstat -t"
        fi

        p_stress_ng="stress-ng"
        if [[ "$ng_ram_time" != "false" ]]; then
            p_stress_ng="$p_stress_ng -t $ng_ram_time"
        fi
        if [[ "$ng_ram_interval" != "false" ]]; then
            p_stress_ng="$p_stress_ng -i $ng_ram_interval"
        fi
        if [[ "$ng_ram_report" != "false" ]]; then
            p_stress_ng="$p_stress_ng -v"
        fi
        if [[ "$ng_ram_vm" != "false" ]]; then
            p_stress_ng="$p_stress_ng --vm $ng_ram_vm"
        fi
        if [[ "$ng_ram_method" != "false" ]]; then
            p_stress_ng="$p_stress_ng --vm-method $ng_ram_method"
        fi
        if [[ "$ng_ram_bytes" != "false" ]]; then
            p_stress_ng="$p_stress_ng --vm-bytes $ng_ram_bytes"
        fi
        if [[ "$ng_ram_vmmax" != "false" ]]; then
            p_stress_ng="$p_stress_ng --vm-max $ng_ram_vmmax"
        fi

        if [[ "$vmstat_v" != "false" ]]; then
            eval "$p_vmstat" >> $vmstat_cpu_test_results &
        fi

        eval "$p_stress_ng" >> $mem_test_results
    fi
    if [[ "$sysbench" = "true" ]]; then
        echo "---Тестирование sysbench---" >> $mem_test_results
        p_sysbench="sysbench memory"
        if [[ "$sb_memory_block_size" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-block-size=$sb_memory_block_size"
        fi
        if [[ "$sb_memory_total_size" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-total-size=$sb_memory_total_size"
        fi
        if [[ "$sb_memory_scope" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-scope=$sb_memory_scope"
        fi
        if [[ "$sb_memory_hugetlb" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-hugetlb=$sb_memory_hugetlb"
        fi
        if [[ "$sb_memory_oper" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-oper=$sb_memory_oper"
        fi
        if [[ "$sb_memory_access_mode" != "false" ]]; then
            p_sysbench="$p_sysbench --memory-access-mode=$sb_memory_access_mode"
        fi
        p_sysbench="$p_sysbench run"
        eval "$p_sysbench" >> $mem_test_results
    fi
    if [[ "$1" = "RAM" && $(pgrep htop) ]]; then
        pkill htop
    fi
fi
#---------------------------------------------Производительность дисков DSK----------------------------------------------
if [[ "$1" = "DSK" || "$1" = "SEQ" ]]; then
    # Запись заголовка в файл
    echo "## Тестирование производительности дисков" >> $file_test_results
    echo "Параметры:" >> $file_test_results
    echo "- Используемый файл, размер: $sb_file_total_size" >> $file_test_results
    echo "- Проводимый тест: $sb_file_test_mode" >> $file_test_results
    echo "- Используемые блоки данных, размер: $sb_file_block_size" >> $file_test_results
    echo "- Количество используемых потоков: $sb_file_threads" >> $file_test_results
    echo "- Время выполнения теста: $sb_file_time секунд" >> $file_test_results
    echo "" >> $file_test_results

    # Тест дисков
    echo "Тестирование производительности дисков..." >> $file_test_results
    if [[ "$sysbench" = "true" ]]; then
        echo "---Тестирование sysbench---" >> $file_test_results
        mkdir fileio_data
        cd fileio_data

        echo "---Тестирование sysbench---" >> $file_test_results
        p_sysbench="sysbench fileio"
        if [[ "$sb_fileio_test_mode" != "false" ]]; then
            p_sysbench="$p_sysbench --file-test-mode=$sb_fileio_test_mode"
        fi
        if [[ "$sb_fileio_file_num" != "false" ]]; then
            p_sysbench="$p_sysbench --file-num=$sb_fileio_file_num"
        fi
        if [[ "$sb_fileio_block_size" != "false" ]]; then
            p_sysbench="$p_sysbench --file-block-size=$sb_fileio_block_size"
        fi
        if [[ "$sb_fileio_total_size" != "false" ]]; then
            p_sysbench="$p_sysbench --file-total-size=$sb_fileio_total_size"
        fi
        if [[ "$sb_fileio_io_mode" != "false" ]]; then
            p_sysbench="$p_sysbench --file-io-mode=$sb_fileio_io_mode"
        fi
        if [[ "$sb_fileio_async_backlog" != "false" ]]; then
            p_sysbench="$p_sysbench --file-async-backlog=$sb_fileio_async_backlog"
        fi
        if [[ "$sb_fileio_extra_flags" != "false" ]]; then
            p_sysbench="$p_sysbench --file-extra-flags=$sb_fileio_extra_flags"
        fi
        if [[ "$sb_fileio_fsync_freq" != "false" ]]; then
            p_sysbench="$p_sysbench --file-fsync-freq=$sb_fileio_fsync_freq"
        fi
        if [[ "$sb_fileio_file_fsync_all" != "false" ]]; then
            p_sysbench="$p_sysbench --file-fsync-all=$sb_fileio_file_fsync_all"
        fi
        if [[ "$sb_fileio_async_backlog" != "false" ]]; then
            p_sysbench="$p_sysbench --file-fsync-end=$sb_fileio_file_fsync_end"
        fi
        if [[ "$sb_fileio_fsync_mode" != "false" ]]; then
            p_sysbench="$p_sysbench --file-fsync-mode=$sb_fileio_fsync_mode"
        fi
        if [[ "$sb_fileio_merged_requests" != "false" ]]; then
            p_sysbench="$p_sysbench --file-merged-requests=$sb_fileio_merged_requests"
        fi
        if [[ "$sb_fileio_rw_ratio" != "false" ]]; then
            p_sysbench="$p_sysbench --file-rw-ratio=$sb_fileio_rw_ratio"
        fi
        p_sysbench="$p_sysbench run"
        eval "$p_sysbench" >> "../$file_test_results"
        cd ..
    fi

    if [[ "$1" = "DSK" && $(pgrep htop) ]]; then
        pkill htop
    fi
fi

if [[ "$1" = "SEQ" && $(pgrep htop) ]]; then
    pkill htop
fi
#-----------------------------------------------------------ALL-----------------------------------------------------------------
if [[ "$1" = "ALL" ]]; then
    # Запись заголовка в файл

    #CPU
    vmstat -w 1 $(($duration_cpu+10)) -t >> $vmstat_cpu_test_results &
    stress -c $num_threads --timeout $duration_cpu >> $cpu_test_results &
    echo "---Тестирование sysbench---" >> $cpu_test_results
    sysbench cpu --threads=$num_threads --cpu-max-prime=$prime_limit run >> $cpu_test_results &&
    stress-ng --vm=$num_vm --vm-bytes=$vm_bytes --vm-method all --timeout=$duration_mem --verify >> "$mem_test_results" &
    sysbench memory --memory-block-size=$sb_memory_block_size --memory-total-size=$sb_memory_total_size --memory-oper=$sb_memory_oper1 --threads=$sb_threads --time=$sb_time run >> "$mem_test_results" &&
    sysbench memory --memory-block-size=$sb_memory_block_size --memory-total-size=$sb_memory_total_size --memory-oper=$sb_memory_oper2 --threads=$sb_threads --time=$sb_time run >> "$mem_test_results" &
    mkdir fileio_data 
    cd fileio_data 
    sysbench fileio --file-total-size=$sb_file_total_size --file-test-mode=$sb_file_test_mode --file-block-size=$sb_file_block_size --threads=$sb_file_threads --time=$sb_file_time run >> "../$file_test_results" &
    cd .. 
fi

echo "Результаты теста сохранены"
