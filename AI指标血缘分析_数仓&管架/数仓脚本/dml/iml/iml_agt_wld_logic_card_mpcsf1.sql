/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_wld_logic_card_mpcsf1
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
drop table ${iml_schema}.agt_wld_logic_card_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_logic_card_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_wld_logic_card add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_wld_logic_card modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_wld_logic_card_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_wld_logic_card partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_wld_logic_card_mpcsf1_tm
compress ${option_switch} for query high
as
select
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,loan_prod_id -- 贷款产品编号
    ,appl_id -- 申请编号
    ,logic_card_main_card_card_id -- 逻辑卡主卡卡编号
    ,latest_med_card_id -- 最新介质卡编号
    ,actvd_flg -- 已激活标志
    ,pin_card_clos_acct_dt -- 销卡销户日期
    ,card_valid_dt -- 卡片有效日期
    ,fir_ucd_dt -- 首次用卡日期
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_wld_logic_card
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_wld_logic_card_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_wld_logic_card partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a0ntm_card-
insert into ${iml_schema}.agt_wld_logic_card_mpcsf1_tm(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,loan_prod_id -- 贷款产品编号
    ,appl_id -- 申请编号
    ,logic_card_main_card_card_id -- 逻辑卡主卡卡编号
    ,latest_med_card_id -- 最新介质卡编号
    ,actvd_flg -- 已激活标志
    ,pin_card_clos_acct_dt -- 销卡销户日期
    ,card_valid_dt -- 卡片有效日期
    ,fir_ucd_dt -- 首次用卡日期
    ,optimit_lock_edit_num -- 乐观锁版本号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '101002'||P1.LOGICAL_CARD_NO -- 凭证编号
    ,'9999' -- 法人编号
    ,P1.LOGICAL_CARD_NO -- 卡号
    ,TO_CHAR(P1.ACCT_NO) -- 账户编号
    ,NVL(p2.cbscustno,' ') -- 客户编号
    ,P1.PRODUCT_CD -- 贷款产品编号
    ,P1.APP_NO -- 申请编号
    ,P1.BSC_LOGICCARD_NO -- 逻辑卡主卡卡编号
    ,P1.LATEST_CARD_NO -- 最新介质卡编号
    ,P1.ACTIVATE_IND -- 已激活标志
    ,P1.CANCEL_DATE -- 销卡销户日期
    ,P1.CARD_EXPIRE_DATE -- 卡片有效日期
    ,P1.FIRST_USAGE_DATE -- 首次用卡日期
    ,TO_CHAR(P1.JPA_VERSION) -- 乐观锁版本号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a0ntm_card' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a0ntm_card p1
    left join ${iol_schema}.mpcs_a0ntm_customer p2 on p1.cust_id=p2.cust_id and   p2.START_DT<=TO_DATE('${batch_date}','YYYYMMDD') AND p2.END_DT>TO_DATE('${batch_date}','YYYYMMDD')
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_wld_logic_card_mpcsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_wld_logic_card_mpcsf1_ex(
    vouch_id -- 凭证编号
    ,lp_id -- 法人编号
    ,card_no -- 卡号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,loan_prod_id -- 贷款产品编号
    ,appl_id -- 申请编号
    ,logic_card_main_card_card_id -- 逻辑卡主卡卡编号
    ,latest_med_card_id -- 最新介质卡编号
    ,actvd_flg -- 已激活标志
    ,pin_card_clos_acct_dt -- 销卡销户日期
    ,card_valid_dt -- 卡片有效日期
    ,fir_ucd_dt -- 首次用卡日期
    ,optimit_lock_edit_num -- 乐观锁版本号
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
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.loan_prod_id, o.loan_prod_id) as loan_prod_id -- 贷款产品编号
    ,nvl(n.appl_id, o.appl_id) as appl_id -- 申请编号
    ,nvl(n.logic_card_main_card_card_id, o.logic_card_main_card_card_id) as logic_card_main_card_card_id -- 逻辑卡主卡卡编号
    ,nvl(n.latest_med_card_id, o.latest_med_card_id) as latest_med_card_id -- 最新介质卡编号
    ,nvl(n.actvd_flg, o.actvd_flg) as actvd_flg -- 已激活标志
    ,nvl(n.pin_card_clos_acct_dt, o.pin_card_clos_acct_dt) as pin_card_clos_acct_dt -- 销卡销户日期
    ,nvl(n.card_valid_dt, o.card_valid_dt) as card_valid_dt -- 卡片有效日期
    ,nvl(n.fir_ucd_dt, o.fir_ucd_dt) as fir_ucd_dt -- 首次用卡日期
    ,nvl(n.optimit_lock_edit_num, o.optimit_lock_edit_num) as optimit_lock_edit_num -- 乐观锁版本号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.vouch_id is null
                and o.lp_id is null
            ) or (
                o.card_no <> n.card_no
                or o.acct_id <> n.acct_id
                or o.cust_id <> n.cust_id
                or o.loan_prod_id <> n.loan_prod_id
                or o.appl_id <> n.appl_id
                or o.logic_card_main_card_card_id <> n.logic_card_main_card_card_id
                or o.latest_med_card_id <> n.latest_med_card_id
                or o.actvd_flg <> n.actvd_flg
                or o.pin_card_clos_acct_dt <> n.pin_card_clos_acct_dt
                or o.card_valid_dt <> n.card_valid_dt
                or o.fir_ucd_dt <> n.fir_ucd_dt
                or o.optimit_lock_edit_num <> n.optimit_lock_edit_num
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
from ${iml_schema}.agt_wld_logic_card_mpcsf1_tm n
    full join ${iml_schema}.agt_wld_logic_card_mpcsf1_bk o
        on
            o.vouch_id = n.vouch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_wld_logic_card truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_wld_logic_card exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_wld_logic_card_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_wld_logic_card drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_wld_logic_card to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_wld_logic_card_mpcsf1_tm purge;
drop table ${iml_schema}.agt_wld_logic_card_mpcsf1_ex purge;
drop table ${iml_schema}.agt_wld_logic_card_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_wld_logic_card', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);