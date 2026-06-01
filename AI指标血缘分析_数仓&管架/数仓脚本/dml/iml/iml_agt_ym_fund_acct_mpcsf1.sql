/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ym_fund_acct_mpcsf1
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
drop table ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_fund_acct_mpcsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ym_fund_acct add partition p_mpcsf1 values ('mpcsf1')(
        subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ym_fund_acct modify partition p_mpcsf1
    add subpartition p_mpcsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ym_fund_acct_mpcsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ym_fund_acct partition for ('mpcsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,open_dt -- 开户日期
    ,open_tm -- 开户时间
    ,serv_plat_abbr -- 服务平台简称
    ,open_flow_num -- 开户流水号
    ,mercht_id -- 商户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,post_acct_bill_flg -- 寄送账单标志
    ,acct_bill_post_way_cd -- 账单寄送方式代码
    ,cust_bear_risk_level_cd -- 客户承受风险等级代码
    ,acct_status_cd -- 账户状态代码
    ,invtor_lev_cd -- 投资者级别代码
    ,info_integy_flg -- 信息完整标志
    ,actl_invtor_name -- 实际投资者姓名
    ,actl_invtor_cert_type_cd -- 实际投资者证件类型代码
    ,actl_invtor_cert_no -- 实际投资者证件号码
    ,actl_invtor_cert_exp_dt -- 实际投资者证件到期日期
    ,invest_benefc_name -- 投资受益人姓名
    ,invest_benefc_cert_type_cd -- 投资受益人证件类型代码
    ,invest_benefc_cert_no -- 投资受益人证件号码
    ,invest_benefc_cert_exp_dt -- 投资受益人证件到期日期
    ,cust_mgr_id -- 客户经理编号
    ,name -- 姓名
    ,zip_cd -- 邮政编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_fund_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ym_fund_acct_mpcsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ym_fund_acct partition for ('mpcsf1') where 0=1;

-- 2.1 insert data to tm table
-- mpcs_a92accinfo-
insert into ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,open_dt -- 开户日期
    ,open_tm -- 开户时间
    ,serv_plat_abbr -- 服务平台简称
    ,open_flow_num -- 开户流水号
    ,mercht_id -- 商户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,post_acct_bill_flg -- 寄送账单标志
    ,acct_bill_post_way_cd -- 账单寄送方式代码
    ,cust_bear_risk_level_cd -- 客户承受风险等级代码
    ,acct_status_cd -- 账户状态代码
    ,invtor_lev_cd -- 投资者级别代码
    ,info_integy_flg -- 信息完整标志
    ,actl_invtor_name -- 实际投资者姓名
    ,actl_invtor_cert_type_cd -- 实际投资者证件类型代码
    ,actl_invtor_cert_no -- 实际投资者证件号码
    ,actl_invtor_cert_exp_dt -- 实际投资者证件到期日期
    ,invest_benefc_name -- 投资受益人姓名
    ,invest_benefc_cert_type_cd -- 投资受益人证件类型代码
    ,invest_benefc_cert_no -- 投资受益人证件号码
    ,invest_benefc_cert_exp_dt -- 投资受益人证件到期日期
    ,cust_mgr_id -- 客户经理编号
    ,name -- 姓名
    ,zip_cd -- 邮政编码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '170000'||P1.CUSTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CUSTNO -- 客户编号
    ,${iml_schema}.dateformat_min(P1.TRANDT) -- 开户日期
    ,${iml_schema}.dateformat_min(P1.TRANDT||P1.TRANTM) -- 开户时间
    ,P1.PAYSYS -- 服务平台简称
    ,P1.TRANSEQNO -- 开户流水号
    ,P1.BROKERCODE -- 商户编号
    ,P1.ACCOUNTID -- 盈米财富账户编号
    ,nvl(trim(P1.ISBILL),'-') -- 寄送账单标志
    ,P1.BILLTYPE -- 账单寄送方式代码
    ,decode(trim(P1.RISKGRADE),0,'-',nvl(trim(P1.RISKGRADE),'-')) -- 客户承受风险等级代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.STAT END -- 账户状态代码
    ,nvl(trim(P1.CUSTLEVEL),'-') -- 投资者级别代码
    ,nvl(trim(P1.INFOREADY),'-') -- 信息完整标志
    ,P1.INVESTORNAME -- 实际投资者姓名
    ,decode(trim(P1.INVESTORIDTYPE),'0','1010',nvl(trim(P1.INVESTORIDTYPE),'0000')) -- 实际投资者证件类型代码
    ,P1.INVESTORIDINFO -- 实际投资者证件号码
    ,${iml_schema}.dateformat_max(P1.INVESTORIDENDDATE) -- 实际投资者证件到期日期
    ,P1.BENEFYNAME -- 投资受益人姓名
    ,decode(trim(P1.BENEFYIDTYPE),'0','1010',nvl(trim(P1.BENEFYIDTYPE),'0000')) -- 投资受益人证件类型代码
    ,P1.BENEFYIDINFO -- 投资受益人证件号码
    ,${iml_schema}.dateformat_max(P1.BENEFYIDENDDATE) -- 投资受益人证件到期日期
    ,P1.MANAGER -- 客户经理编号
    ,P1.ACCOUNTNAME -- 姓名
    ,P1.ZIPCD -- 邮政编码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'mpcs_a92accinfo' -- 源表名称
    ,'mpcsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.mpcs_a92accinfo p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.STAT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'MPCS'
        AND R2.SRC_TAB_EN_NAME= 'MPCS_A92ACCINFO'
        AND R2.SRC_FIELD_EN_NAME= 'STAT'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_YM_FUND_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ACCT_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_status_cd
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
insert /*+ append */ into ${iml_schema}.agt_ym_fund_acct_mpcsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cust_id -- 客户编号
    ,open_dt -- 开户日期
    ,open_tm -- 开户时间
    ,serv_plat_abbr -- 服务平台简称
    ,open_flow_num -- 开户流水号
    ,mercht_id -- 商户编号
    ,ym_riches_acct_id -- 盈米财富账户编号
    ,post_acct_bill_flg -- 寄送账单标志
    ,acct_bill_post_way_cd -- 账单寄送方式代码
    ,cust_bear_risk_level_cd -- 客户承受风险等级代码
    ,acct_status_cd -- 账户状态代码
    ,invtor_lev_cd -- 投资者级别代码
    ,info_integy_flg -- 信息完整标志
    ,actl_invtor_name -- 实际投资者姓名
    ,actl_invtor_cert_type_cd -- 实际投资者证件类型代码
    ,actl_invtor_cert_no -- 实际投资者证件号码
    ,actl_invtor_cert_exp_dt -- 实际投资者证件到期日期
    ,invest_benefc_name -- 投资受益人姓名
    ,invest_benefc_cert_type_cd -- 投资受益人证件类型代码
    ,invest_benefc_cert_no -- 投资受益人证件号码
    ,invest_benefc_cert_exp_dt -- 投资受益人证件到期日期
    ,cust_mgr_id -- 客户经理编号
    ,name -- 姓名
    ,zip_cd -- 邮政编码
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
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.open_dt, o.open_dt) as open_dt -- 开户日期
    ,nvl(n.open_tm, o.open_tm) as open_tm -- 开户时间
    ,nvl(n.serv_plat_abbr, o.serv_plat_abbr) as serv_plat_abbr -- 服务平台简称
    ,nvl(n.open_flow_num, o.open_flow_num) as open_flow_num -- 开户流水号
    ,nvl(n.mercht_id, o.mercht_id) as mercht_id -- 商户编号
    ,nvl(n.ym_riches_acct_id, o.ym_riches_acct_id) as ym_riches_acct_id -- 盈米财富账户编号
    ,nvl(n.post_acct_bill_flg, o.post_acct_bill_flg) as post_acct_bill_flg -- 寄送账单标志
    ,nvl(n.acct_bill_post_way_cd, o.acct_bill_post_way_cd) as acct_bill_post_way_cd -- 账单寄送方式代码
    ,nvl(n.cust_bear_risk_level_cd, o.cust_bear_risk_level_cd) as cust_bear_risk_level_cd -- 客户承受风险等级代码
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.invtor_lev_cd, o.invtor_lev_cd) as invtor_lev_cd -- 投资者级别代码
    ,nvl(n.info_integy_flg, o.info_integy_flg) as info_integy_flg -- 信息完整标志
    ,nvl(n.actl_invtor_name, o.actl_invtor_name) as actl_invtor_name -- 实际投资者姓名
    ,nvl(n.actl_invtor_cert_type_cd, o.actl_invtor_cert_type_cd) as actl_invtor_cert_type_cd -- 实际投资者证件类型代码
    ,nvl(n.actl_invtor_cert_no, o.actl_invtor_cert_no) as actl_invtor_cert_no -- 实际投资者证件号码
    ,nvl(n.actl_invtor_cert_exp_dt, o.actl_invtor_cert_exp_dt) as actl_invtor_cert_exp_dt -- 实际投资者证件到期日期
    ,nvl(n.invest_benefc_name, o.invest_benefc_name) as invest_benefc_name -- 投资受益人姓名
    ,nvl(n.invest_benefc_cert_type_cd, o.invest_benefc_cert_type_cd) as invest_benefc_cert_type_cd -- 投资受益人证件类型代码
    ,nvl(n.invest_benefc_cert_no, o.invest_benefc_cert_no) as invest_benefc_cert_no -- 投资受益人证件号码
    ,nvl(n.invest_benefc_cert_exp_dt, o.invest_benefc_cert_exp_dt) as invest_benefc_cert_exp_dt -- 投资受益人证件到期日期
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.name, o.name) as name -- 姓名
    ,nvl(n.zip_cd, o.zip_cd) as zip_cd -- 邮政编码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
                and o.acct_status_cd is null
            ) or (
                o.cust_id <> n.cust_id
                or o.open_dt <> n.open_dt
                or o.open_tm <> n.open_tm
                or o.serv_plat_abbr <> n.serv_plat_abbr
                or o.open_flow_num <> n.open_flow_num
                or o.mercht_id <> n.mercht_id
                or o.ym_riches_acct_id <> n.ym_riches_acct_id
                or o.post_acct_bill_flg <> n.post_acct_bill_flg
                or o.acct_bill_post_way_cd <> n.acct_bill_post_way_cd
                or o.cust_bear_risk_level_cd <> n.cust_bear_risk_level_cd
                or o.invtor_lev_cd <> n.invtor_lev_cd
                or o.info_integy_flg <> n.info_integy_flg
                or o.actl_invtor_name <> n.actl_invtor_name
                or o.actl_invtor_cert_type_cd <> n.actl_invtor_cert_type_cd
                or o.actl_invtor_cert_no <> n.actl_invtor_cert_no
                or o.actl_invtor_cert_exp_dt <> n.actl_invtor_cert_exp_dt
                or o.invest_benefc_name <> n.invest_benefc_name
                or o.invest_benefc_cert_type_cd <> n.invest_benefc_cert_type_cd
                or o.invest_benefc_cert_no <> n.invest_benefc_cert_no
                or o.invest_benefc_cert_exp_dt <> n.invest_benefc_cert_exp_dt
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.name <> n.name
                or o.zip_cd <> n.zip_cd
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                           and n.acct_status_cd is null
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
                and n.acct_status_cd is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm n
    full join ${iml_schema}.agt_ym_fund_acct_mpcsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_status_cd = n.acct_status_cd
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ym_fund_acct truncate partition for ('mpcsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ym_fund_acct exchange subpartition p_mpcsf1_${batch_date} with table ${iml_schema}.agt_ym_fund_acct_mpcsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ym_fund_acct drop subpartition p_mpcsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ym_fund_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ym_fund_acct_mpcsf1_tm purge;
drop table ${iml_schema}.agt_ym_fund_acct_mpcsf1_ex purge;
drop table ${iml_schema}.agt_ym_fund_acct_mpcsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ym_fund_acct', partname => 'p_mpcsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);