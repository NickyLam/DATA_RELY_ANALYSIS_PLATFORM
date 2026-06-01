/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_ast_obank_dep_rcpt_inpwn_info_mimsf1
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
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info add partition p_mimsf1 values ('mimsf1')(
        subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info modify partition p_mimsf1
    add subpartition p_mimsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info partition for ('mimsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm
compress ${option_switch} for query high
as
select
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,aval_amt -- 可用金额
    ,bank_name -- 银行名称
    ,bank_rgst_cd -- 银行注册地代码
    ,ext_rating_dt -- 外部评级日期
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,dep_term -- 存期
    ,int_rat -- 利率
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info partition for ('mimsf1') where 0=1;

-- 2.1 insert data to tm table
-- mims_si_otherdeposit-
insert into ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,aval_amt -- 可用金额
    ,bank_name -- 银行名称
    ,bank_rgst_cd -- 银行注册地代码
    ,ext_rating_dt -- 外部评级日期
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,dep_term -- 存期
    ,int_rat -- 利率
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,remark -- 备注
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.SCCODE -- 资产编号
    ,'9999' -- 法人编号
    ,P1.CERTIFICATECODE -- 凭证编号
    ,P1.STOPPAYMENTMONEY -- 可用金额
    ,P1.ACCOUNTNAME -- 银行名称
    ,NVL(TRIM(P1.REGISTCOUNTRY),'XXX') -- 银行注册地代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.OUTRATINGDATE) -- 外部评级日期
    ,NVL(TRIM(P1.OUTRATINGRESULT),'-') -- 外部评级结果代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.STARTDATE) -- 生效日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.ENDDATE) -- 到期日期
    ,P1.DUEDATE -- 存期
    ,P1.YEARRATE -- 利率
    ,P1.MONEY -- 本金金额
    ,NVL(TRIM(P1.TDCURRENCY),'-') -- 币种代码
    ,P1.REMARK -- 备注
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mims_si_otherdeposit' -- 源表名称
    ,'mimsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mims_si_otherdeposit p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm 
  	                                group by 
  	                                        asset_id
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
insert /*+ append */ into ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_ex(
    asset_id -- 资产编号
    ,lp_id -- 法人编号
    ,vouch_id -- 凭证编号
    ,aval_amt -- 可用金额
    ,bank_name -- 银行名称
    ,bank_rgst_cd -- 银行注册地代码
    ,ext_rating_dt -- 外部评级日期
    ,ext_rating_rest_cd -- 外部评级结果代码
    ,effect_dt -- 生效日期
    ,exp_dt -- 到期日期
    ,dep_term -- 存期
    ,int_rat -- 利率
    ,pric_amt -- 本金金额
    ,curr_cd -- 币种代码
    ,remark -- 备注
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.asset_id, o.asset_id) as asset_id -- 资产编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.vouch_id, o.vouch_id) as vouch_id -- 凭证编号
    ,nvl(n.aval_amt, o.aval_amt) as aval_amt -- 可用金额
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.bank_rgst_cd, o.bank_rgst_cd) as bank_rgst_cd -- 银行注册地代码
    ,nvl(n.ext_rating_dt, o.ext_rating_dt) as ext_rating_dt -- 外部评级日期
    ,nvl(n.ext_rating_rest_cd, o.ext_rating_rest_cd) as ext_rating_rest_cd -- 外部评级结果代码
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.dep_term, o.dep_term) as dep_term -- 存期
    ,nvl(n.int_rat, o.int_rat) as int_rat -- 利率
    ,nvl(n.pric_amt, o.pric_amt) as pric_amt -- 本金金额
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.asset_id is null
                and o.lp_id is null
            ) or (
                o.vouch_id <> n.vouch_id
                or o.aval_amt <> n.aval_amt
                or o.bank_name <> n.bank_name
                or o.bank_rgst_cd <> n.bank_rgst_cd
                or o.ext_rating_dt <> n.ext_rating_dt
                or o.ext_rating_rest_cd <> n.ext_rating_rest_cd
                or o.effect_dt <> n.effect_dt
                or o.exp_dt <> n.exp_dt
                or o.dep_term <> n.dep_term
                or o.int_rat <> n.int_rat
                or o.pric_amt <> n.pric_amt
                or o.curr_cd <> n.curr_cd
                or o.remark <> n.remark
            ) or (
                 case when (
                           n.asset_id is null
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
                n.asset_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm n
    full join ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_bk o
        on
            o.asset_id = n.asset_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info truncate partition for ('mimsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info exchange subpartition p_mimsf1_${batch_date} with table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info drop subpartition p_mimsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.ast_obank_dep_rcpt_inpwn_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_tm purge;
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_ex purge;
drop table ${iml_schema}.ast_obank_dep_rcpt_inpwn_info_mimsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'ast_obank_dep_rcpt_inpwn_info', partname => 'p_mimsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);