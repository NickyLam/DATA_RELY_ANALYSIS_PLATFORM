/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_blank_vouch_bdmsf1
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
drop table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_blank_vouch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_blank_vouch modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_blank_vouch partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm
compress ${option_switch} for query high
as
select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dtl_id -- 明细编号
    ,batch_id -- 批次编号
    ,bill_num -- 票据号码
    ,vouch_status_cd -- 凭证状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,bill_type_cd -- 票据类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_blank_vouch
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_blank_vouch partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_blank_voucher_details-
insert into ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dtl_id -- 明细编号
    ,batch_id -- 批次编号
    ,bill_num -- 票据号码
    ,vouch_status_cd -- 凭证状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,bill_type_cd -- 票据类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101009'||P1.ID -- 凭证编号
    ,'9999' -- 法人编号
    ,P1.ID -- 明细编号
    ,P1.BATCH_ID -- 批次编号
    ,P1.DRAFT_NUMBER -- 票据号码
    ,nvl(trim(P1.VOUCHER_STATE),'-') -- 凭证状态代码
    ,to_char(P1.LAST_UPD_OPER_NO) -- 登记柜员编号
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_blank_voucher_details' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_blank_voucher_details p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_BLANK_VOUCHER_DETAILS'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_BLANK_VOUCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm 
  	                                group by 
  	                                        vouch_id
  	                                        ,lp_id
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
insert /*+ append */ into ${iml_schema}.agt_bill_blank_vouch_bdmsf1_ex(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,dtl_id -- 明细编号
    ,batch_id -- 批次编号
    ,bill_num -- 票据号码
    ,vouch_status_cd -- 凭证状态代码
    ,rgst_teller_id -- 登记柜员编号
    ,bill_type_cd -- 票据类型代码
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dtl_id, o.dtl_id) as dtl_id -- 明细编号
    ,nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.bill_num, o.bill_num) as bill_num -- 票据号码
    ,nvl(n.vouch_status_cd, o.vouch_status_cd) as vouch_status_cd -- 凭证状态代码
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.vouch_id is null
                and o.lp_id is null
            ) or (
                o.dtl_id <> n.dtl_id
                or o.batch_id <> n.batch_id
                or o.bill_num <> n.bill_num
                or o.vouch_status_cd <> n.vouch_status_cd
                or o.rgst_teller_id <> n.rgst_teller_id
                or o.bill_type_cd <> n.bill_type_cd
            ) or (
                 case when (
                           n.vouch_id is null
                           and n.lp_id is null
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
                n.vouch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_blank_vouch_bdmsf1_bk o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_blank_vouch truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_blank_vouch exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_blank_vouch drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_blank_vouch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_blank_vouch_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_blank_vouch', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);