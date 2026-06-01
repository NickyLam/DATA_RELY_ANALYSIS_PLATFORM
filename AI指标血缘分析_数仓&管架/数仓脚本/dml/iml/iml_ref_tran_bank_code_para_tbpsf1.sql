/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ref_tran_bank_code_para_tbpsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm purge;
drop table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ref_tran_bank_code_para add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ref_tran_bank_code_para modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ref_tran_bank_code_para partition for ('tbpsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm
compress ${option_switch} for query high
as
select
    tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tran_bank_code_para
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ref_tran_bank_code_para partition for ('tbpsf1') where 0=1;

-- 2.1 insert data to tm table
-- tbps_cpr_transcode_inf-
insert into ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm(
    tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.CTI_TRANSCODE -- 交易码
    ,P1.CTI_TRANSNAME -- 交易名称
    ,P1.CTI_TRANSFLAG -- 金融交易标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_transcode_inf' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_transcode_inf p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm 
  	                                group by 
  	                                        tran_code
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.ref_tran_bank_code_para_tbpsf1_ex(
    tran_code -- 交易码
    ,tran_name -- 交易名称
    ,fin_tran_flg -- 金融交易标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.tran_code, o.tran_code) as tran_code -- 交易码
    ,nvl(n.tran_name, o.tran_name) as tran_name -- 交易名称
    ,nvl(n.fin_tran_flg, o.fin_tran_flg) as fin_tran_flg -- 金融交易标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.tran_code is null
            ) or (
                o.tran_name <> n.tran_name
                or o.fin_tran_flg <> n.fin_tran_flg
            ) or (
                 case when (
                           n.tran_code is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.tran_code is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm n
    full join ${iml_schema}.ref_tran_bank_code_para_tbpsf1_bk o
        on
            o.tran_code = n.tran_code
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ref_tran_bank_code_para truncate partition for ('tbpsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ref_tran_bank_code_para exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ref_tran_bank_code_para drop subpartition p_tbpsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ref_tran_bank_code_para to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_tm purge;
drop table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_ex purge;
drop table ${iml_schema}.ref_tran_bank_code_para_tbpsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ref_tran_bank_code_para', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);