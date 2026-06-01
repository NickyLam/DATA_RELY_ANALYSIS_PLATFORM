/*
Purpose:    指标模型层-设备清机加钞信息表，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_mcyy_base_d_equip_add_cash_info
CreateDate: 20210705
修改记录：
    郑沛隆 2021-07-05 新建脚本 
    依赖于源表：
    DEV_CASH_CLEAR => ITL_EDW_ATMS_DEV_CASH_CLEAR
    DEV_BASE_INFO => MSL_ATMS_DEV_BASE_INFO
    DEV_CATALOG_TABLE => MSL_ATMS_DEV_CATALOG_TABLE
    DEV_RESPONSOR_TABLE => MSL_ATMS_DEV_RESPONSOR_TABLE
    bank_manager_persion => MSL_ATMS_bank_manager_persion
	陈雪华 2026-04-10 优化清机时长取数逻辑

*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.base_d_equip_add_cash_info_${batch_date}_tm purge ;
alter table ${idl_schema}.base_d_equip_add_cash_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_equip_add_cash_info_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.base_d_equip_add_cash_info
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table

INSERT INTO ${idl_schema}.base_d_equip_add_cash_info_${batch_date}_tm
    (add_cash_ind_no --VARCHAR2(20)  加钞标识号 
    ,add_cash_dt --VARCHAR2(20)  加钞日期 
    ,equip_belong_org_code --VARCHAR2(20)  设备所属机构编码 
    ,equip_id --VARCHAR2(20)  设备编号 
    ,inst_addr --VARCHAR2(2000)装机地址 
    ,self_equip_type --VARCHAR2(20)  自助设备类型 
    ,self_equip_type_name --VARCHAR2(20)  自助设备类型名称 
    ,equip_mger_member --VARCHAR2(200) 设备管理人员 
    ,in_bank_out_bank_idf --VARCHAR2(10)  在行离行标识 
    ,equip_oper_status --VARCHAR2(10)  设备运营状态 
    ,equip_status --VARCHAR2(10)  设备状态 
    ,cash_start_tm --DATE          清机开始时间 
    ,cash_end_tm --DATE          清机结束时间 
    ,cash_duran --NUMBER(16,2)  清机时长 
    ,bf_minor_add_cash_amt --NUMBER(38,8)  前次加钞金额 
    ,draw_amt --NUMBER(38,8)  取款金额 
    ,dep_amt --NUMBER(38,8)  存款金额 
    ,surp_amt --NUMBER(38,8)  剩余金额 
    ,callbk_cnt --NUMBER(16,2)  回收张数 
    ,ths_tm_add_cash_tot --NUMBER(38,8)  本次加钞总额 
    ,etl_dt --DATE          ETL处理日期 
    ,etl_timestamp --TIMESTAMP(6)  ETL处理时间戳 
     )

    SELECT t1.addcash_id AS add_cash_ind_no --加钞标识号 
          ,substr(t1.addcash_id
                 ,1
                 ,8) AS add_cash_dt --加钞日期
          ,t2.org_no AS equip_belong_org_code --设备所属机构编码
          ,t1.dev_no AS equip_id --设备编号
          ,t2.address AS inst_addr --装机地址
          ,t3.name AS self_equip_type --自助设备类型
          ,t3.enname AS self_equip_type_name --自助设备类型名称
          ,t5.name AS equip_mger_member --设备管理人员
          ,t2.away_flag AS in_bank_out_bank_idf --在行离行标识        
          ,t2.operate_status AS equip_oper_status --设备运营状态
          ,t2.status AS equip_status --设备状态
          ,to_date(trim(t1.clear_datetime)
                  ,'YYYY-MM-DD hh24:mi:ss') AS cash_start_tm --清机开始时间
          ,to_date(lead(nvl(trim(t1.addcash_datetime)
                           ,'')
                       ,1
                       ,'')
                   over(PARTITION BY t1.dev_no ORDER BY t1.addcash_id ASC)
                  ,'YYYY-MM-DD hh24:mi:ss') AS cash_end_tm --清机结束时间
          ,CASE
               WHEN lead(nvl(trim(t1.addcash_datetime)
                            ,'')
                        ,1
                        ,'')
                over(PARTITION BY t1.dev_no ORDER BY t1.addcash_datetime ASC) IS NOT NULL THEN
                round(abs(to_number(to_date(lead(nvl(trim(t1.addcash_datetime)
                                                ,'')
                                            ,1
                                            ,'')
                                        over(PARTITION BY t1.dev_no ORDER BY
                                             t1.addcash_datetime ASC)
                                       ,'YYYY-MM-DD hh24:mi:ss') -
                                to_date(trim(t1.clear_datetime)
                                       ,'YYYY-MM-DD hh24:mi:ss'))) * 24 * 60,2)
               ELSE
                0
           END AS cash_duran --清机时长
    , nvl(t1.addcash_amount, 0) AS bf_minor_add_cash_amt --前次加钞金额
    , nvl(t1.withdraw_amount, 0) AS draw_amt --取款金额
    , nvl(t1.deposit_amount, 0) AS dep_amt --存款金额
    , nvl(t1.addcash_lastamount, 0) AS surp_amt --剩余金额
    , nvl(t1.addcash_retractcount, 0) AS callbk_cnt --回收张数
    , lead(nvl(t1.addcash_amount, '0'), 1, '0') over(PARTITION BY t1.dev_no
    ORDER  BY t1.addcash_id ASC) AS ths_tm_add_cash_tot --本次加钞总额
    , to_date('${batch_date}', 'yyyymmdd') AS etl_dt -- ETL处理日期
    , to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp -- ETL处理时间戳     
    FROM   itl_edw_atms_dev_cash_clear t1
    INNER  JOIN msl_atms_dev_base_info t2
    ON     t2.no = t1.dev_no
    LEFT   JOIN msl_atms_dev_catalog_table t3
    ON     t2.dev_catalog = t3.no
    LEFT   JOIN (SELECT d.dev_no
                       ,listagg(o.name
                               ,',') AS NAME
                 FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                 WHERE  to_char(d.RESPONSER_NO) = o.no
                 AND    d.catalog = 1
                 AND    d.grade = 1
                 GROUP  BY d.dev_no) t5
    ON     t5.dev_no = t1.dev_no
    WHERE  ((trunc(to_date(trim(t1.clear_datetime)
                          ,'YYYY-MM-DD hh24:mi:ss')) >=
           to_date('${batch_date}'
                    ,'yyyymmdd') AND
           trunc(to_date(trim(t1.clear_datetime)
                          ,'YYYY-MM-DD hh24:mi:ss')) <=
           to_date('${batch_date}'
                    ,'yyyymmdd')) OR
           trunc(to_date(trim(t1.addcash_datetime)
                         ,'YYYY-MM-DD hh24:mi:ss')) >=
           to_date('${batch_date}'
                   ,'yyyymmdd') AND
           trunc(to_date(trim(t1.addcash_datetime)
                         ,'YYYY-MM-DD hh24:mi:ss')) <=
           to_date('${batch_date}'
                   ,'yyyymmdd'))
    ORDER  BY t1.dev_no, trim(t1.clear_datetime);



COMMIT;


-- 3.2 truncate target table batch_date partition
alter table ${idl_schema}.base_d_equip_add_cash_info truncate partition p_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${idl_schema}.base_d_equip_add_cash_info exchange partition p_${batch_date} with table ${idl_schema}.base_d_equip_add_cash_info_${batch_date}_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${idl_schema}.base_d_equip_add_cash_info to ${idl_schema};

-- 4.2 drop tm table
drop table ${idl_schema}.base_d_equip_add_cash_info_${batch_date}_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'base_d_equip_add_cash_info', partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);