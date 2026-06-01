/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_agreement_ctmsf1
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
drop table ${iml_schema}.agt_agreement_ctmsf1_tm purge;
drop table ${iml_schema}.agt_agreement_ctmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_agreement add partition p_ctmsf1 values ('ctmsf1')(
        subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_agreement modify partition p_ctmsf1
    add subpartition p_ctmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_agreement_ctmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_agreement partition for ('ctmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_agreement_ctmsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_agreement
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_agreement_ctmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_agreement partition for ('ctmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ctms_fbs_v_fit_deal-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224102'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'224102' -- 协议类型代码
    ,P1.DEAL_DATE -- 协议生效日期
    ,P1.TRNSFR_DATE -- 协议失效日期
    ,' ' -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_fit_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_fit_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_fbs_v_ibo_deal-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224103'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'224103' -- 协议类型代码
    ,P1.VALUE_DATE -- 协议生效日期
    ,P1.MATURITY_DATE -- 协议失效日期
    ,' ' -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_ibo_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_ibo_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_fbs_v_spot_deal-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224104'||P1.DEAL_SQNO -- 协议编号
    ,'9999' -- 法人编号
    ,' ' -- 源协议编号
    ,' ' -- 协议名称
    ,'224104' -- 协议类型代码
    ,P1.DEAL_DATE -- 协议生效日期
    ,P1.VALUE_DATE -- 协议失效日期
    ,' ' -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_fbs_v_spot_deal' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_fbs_v_spot_deal p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_addonportfolio-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '160011'||TO_CHAR(P1.ADDONPORTFOLIO_ID)||LPAD(TRIM(P1.NSTD_ID_DEFAULT),5,'0') -- 协议编号
    ,'9999' -- 法人编号
    ,P1.ADDONPORTFOLIO_ID -- 源协议编号
    ,P1.OWNER_NAME -- 协议名称
    ,'160011' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MIN(NULL) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(NULL) -- 协议失效日期
    ,' ' -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_addonportfolio' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_addonportfolio p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_bondsdeals-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225101'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'225101' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADEDATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTLEDATE) -- 协议失效日期
    ,P1.DEALER_ID -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_bondsdeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_bondsdeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_iamdeals-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '224101'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'224101' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 协议失效日期
    ,P1.DEALER_ID -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_iamdeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_iamdeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_ldrepodeals-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225102'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'225102' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 协议失效日期
    ,P1.DEALER_ID -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_ldrepodeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_ldrepodeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_openrepodeals-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225103'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'225103' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 协议失效日期
    ,P1.DEALER_ID -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_openrepodeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_openrepodeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_repodeals-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225104'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'225104' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 协议失效日期
    ,P1.DEALER_ID -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_repodeals' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_repodeals p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- ctms_tbs_vs_payment_wtrade_lend-
insert into ${iml_schema}.agt_agreement_ctmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '225105'||TO_CHAR(P1.DEAL_ID) -- 协议编号
    ,'9999' -- 法人编号
    ,TO_CHAR(P1.DEAL_ID) -- 源协议编号
    ,P1.DEAL_TABLENAME -- 协议名称
    ,'225105' -- 协议类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TRADE_DATE) -- 协议生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.MATURITY_DATE) -- 协议失效日期
    ,P1.DEALER -- 签约柜员编号
    ,' ' -- 签约机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ctms_tbs_vs_payment_wtrade_lend' -- 源表名称
    ,'ctmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_agreement_ctmsf1_tm 
  	                                group by 
  	                                        agt_id
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
insert /*+ append */ into ${iml_schema}.agt_agreement_ctmsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,src_agt_id -- 源协议编号
    ,agt_name -- 协议名称
    ,agt_type_cd -- 协议类型代码
    ,agt_effect_dt -- 协议生效日期
    ,agt_invalid_dt -- 协议失效日期
    ,sign_teller_id -- 签约柜员编号
    ,sign_org_id -- 签约机构编号
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.src_agt_id, o.src_agt_id) as src_agt_id -- 源协议编号
    ,nvl(n.agt_name, o.agt_name) as agt_name -- 协议名称
    ,nvl(n.agt_type_cd, o.agt_type_cd) as agt_type_cd -- 协议类型代码
    ,nvl(n.agt_effect_dt, o.agt_effect_dt) as agt_effect_dt -- 协议生效日期
    ,nvl(n.agt_invalid_dt, o.agt_invalid_dt) as agt_invalid_dt -- 协议失效日期
    ,nvl(n.sign_teller_id, o.sign_teller_id) as sign_teller_id -- 签约柜员编号
    ,nvl(n.sign_org_id, o.sign_org_id) as sign_org_id -- 签约机构编号
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.src_agt_id <> n.src_agt_id
                or o.agt_name <> n.agt_name
                or o.agt_type_cd <> n.agt_type_cd
                or o.agt_effect_dt <> n.agt_effect_dt
                or o.agt_invalid_dt <> n.agt_invalid_dt
                or o.sign_teller_id <> n.sign_teller_id
                or o.sign_org_id <> n.sign_org_id
            ) or (
                 case when (
                           n.agt_id is null
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
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_agreement_ctmsf1_tm n
    full join ${iml_schema}.agt_agreement_ctmsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_agreement truncate partition for ('ctmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_agreement exchange subpartition p_ctmsf1_${batch_date} with table ${iml_schema}.agt_agreement_ctmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_agreement drop subpartition p_ctmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_agreement to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_agreement_ctmsf1_tm purge;
drop table ${iml_schema}.agt_agreement_ctmsf1_ex purge;
drop table ${iml_schema}.agt_agreement_ctmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_agreement', partname => 'p_ctmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);