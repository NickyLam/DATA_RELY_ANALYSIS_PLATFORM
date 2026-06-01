/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_catalog_table
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM atms_dev_catalog_table_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('atms_dev_catalog_table');
  
  if v_var <> 0 then 
    execute immediate 'alter table atms_dev_catalog_table drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table atms_dev_catalog_table add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.atms_dev_catalog_table(
            no -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            to_char(no) -- 编号 10001 自动存取款机(CRS) 10002 自动存款机(CDM) 10003 自动取款机(ATM) 10004 BSM/查询机 10005   大额机/智能终端/现钞机 10006   回单机 10007   填单机 10008   发卡机 10009   叫号机 10010   广告屏
            ,name -- 设备类型
            ,enname -- 描述
            ,' ' as monitor_type -- 监控类型[1:传统现金自助设备][2:发卡机][3:非现金自助设备] [4:多媒体渠道][5:新型现金自助设备][6:回单机][7:填单机][8:叫号机] [其它 不需要监控的设备]
            ,' ' as channel_type -- 渠道类型[1:现金渠道][2:回单渠道][4:STM渠道]
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_dev_catalog_table_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
