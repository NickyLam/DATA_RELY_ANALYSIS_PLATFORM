/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_tran_bank_acct_tbpsf1
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
drop table ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm purge;
drop table ${iml_schema}.agt_tran_bank_acct_tbpsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_tran_bank_acct add partition p_tbpsf1 values ('tbpsf1')(
        subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_tran_bank_acct modify partition p_tbpsf1
    add subpartition p_tbpsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_tran_bank_acct_tbpsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_tran_bank_acct partition for ('tbpsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,operr_id -- 操作员编号
    ,operr_name -- 操作员名称
    ,acct_cate_cd -- 账户类别代码
    ,acct_name -- 账户名称
    ,ec_idf_cd -- 钞汇标识代码
    ,curr_cd -- 币种代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_status_cd -- 账户状态代码
    ,sign_flg -- 签约标志
    ,sign_chn_cd -- 签约渠道代码
    ,hide_flg -- 隐藏标志
    ,prvlg_open_flg -- 权限开通标志
    ,src_sys_cd -- 来源系统代码
    ,fir_bind_tm -- 首次绑定时间
    ,rels_dt -- 解约日期
    ,core_open_tm -- 核心开户时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_tran_bank_acct
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_tran_bank_acct_tbpsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_tran_bank_acct partition for ('tbpsf1') where 0=1;

-- 2.1 insert data to tm table
-- tbps_cpr_acc_inf-1
insert into ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,operr_id -- 操作员编号
    ,operr_name -- 操作员名称
    ,acct_cate_cd -- 账户类别代码
    ,acct_name -- 账户名称
    ,ec_idf_cd -- 钞汇标识代码
    ,curr_cd -- 币种代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_status_cd -- 账户状态代码
    ,sign_flg -- 签约标志
    ,sign_chn_cd -- 签约渠道代码
    ,hide_flg -- 隐藏标志
    ,prvlg_open_flg -- 权限开通标志
    ,src_sys_cd -- 来源系统代码
    ,fir_bind_tm -- 首次绑定时间
    ,rels_dt -- 解约日期
    ,core_open_tm -- 核心开户时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '221009'||P1.CAI_CSTNO||P1.CAI_ACCNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CAI_ACCNO -- 账户编号
    ,P1.CAI_CSTNO -- 客户编号
    ,P1.CAI_USERNO -- 操作员编号
    ,P1.CAI_USERALIAS -- 操作员名称
    ,nvl(trim(P1.CAI_ACCTYPE),'-') -- 账户类别代码
    ,P1.CAI_ACCNAME -- 账户名称
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CAI_CRFLAG END -- 钞汇标识代码
    ,P1.CAI_CRYTYPE -- 币种代码
    ,P1.CAI_BRANCHNO -- 开户机构编号
    ,NVL(TRIM(P1.CAI_STATE),'-') -- 账户状态代码
    ,P1.CAI_SIGNFLAG -- 签约标志
    ,nvl(trim(P1.CAI_SIGNWAY),'-') -- 签约渠道代码
    ,P1.CAI_HIDE -- 隐藏标志
    ,P1.CAI_RIGHT -- 权限开通标志
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.CAI_SOURCESYS END -- 来源系统代码
    ,${iml_schema}.dateformat_min(TRIM(P1.CAI_FIRSTTIME)) -- 首次绑定时间
    ,${iml_schema}.dateformat_max(TRIM(P1.CAI_CLOSEDATE)) -- 解约日期
    ,${iml_schema}.dateformat_min(TRIM(P1.CAI_OPENDATE)) -- 核心开户时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tbps_cpr_acc_inf' -- 源表名称
    ,'tbpsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tbps_cpr_acc_inf p1
    left join ${iml_schema}.ref_pub_cd_map r1 on nvl(trim(P1.CAI_CRFLAG),' ') = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'TBPS'
        AND R1.SRC_TAB_EN_NAME= 'TBPS_CPR_ACC_INF'
        AND R1.SRC_FIELD_EN_NAME= 'CAI_CRFLAG'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_TRAN_BANK_ACCT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'EC_IDF_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.CAI_SOURCESYS = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'TBPS'
        AND R2.SRC_TAB_EN_NAME= 'TBPS_CPR_ACC_INF'
        AND R2.SRC_FIELD_EN_NAME= 'CAI_SOURCESYS'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_TRAN_BANK_ACCT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'SRC_SYS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_tran_bank_acct_tbpsf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,cust_id -- 客户编号
    ,operr_id -- 操作员编号
    ,operr_name -- 操作员名称
    ,acct_cate_cd -- 账户类别代码
    ,acct_name -- 账户名称
    ,ec_idf_cd -- 钞汇标识代码
    ,curr_cd -- 币种代码
    ,open_acct_org_id -- 开户机构编号
    ,acct_status_cd -- 账户状态代码
    ,sign_flg -- 签约标志
    ,sign_chn_cd -- 签约渠道代码
    ,hide_flg -- 隐藏标志
    ,prvlg_open_flg -- 权限开通标志
    ,src_sys_cd -- 来源系统代码
    ,fir_bind_tm -- 首次绑定时间
    ,rels_dt -- 解约日期
    ,core_open_tm -- 核心开户时间
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.operr_name, o.operr_name) as operr_name -- 操作员名称
    ,nvl(n.acct_cate_cd, o.acct_cate_cd) as acct_cate_cd -- 账户类别代码
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.ec_idf_cd, o.ec_idf_cd) as ec_idf_cd -- 钞汇标识代码
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.sign_flg, o.sign_flg) as sign_flg -- 签约标志
    ,nvl(n.sign_chn_cd, o.sign_chn_cd) as sign_chn_cd -- 签约渠道代码
    ,nvl(n.hide_flg, o.hide_flg) as hide_flg -- 隐藏标志
    ,nvl(n.prvlg_open_flg, o.prvlg_open_flg) as prvlg_open_flg -- 权限开通标志
    ,nvl(n.src_sys_cd, o.src_sys_cd) as src_sys_cd -- 来源系统代码
    ,nvl(n.fir_bind_tm, o.fir_bind_tm) as fir_bind_tm -- 首次绑定时间
    ,nvl(n.rels_dt, o.rels_dt) as rels_dt -- 解约日期
    ,nvl(n.core_open_tm, o.core_open_tm) as core_open_tm -- 核心开户时间
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.acct_id <> n.acct_id
                or o.cust_id <> n.cust_id
                or o.operr_id <> n.operr_id
                or o.operr_name <> n.operr_name
                or o.acct_cate_cd <> n.acct_cate_cd
                or o.acct_name <> n.acct_name
                or o.ec_idf_cd <> n.ec_idf_cd
                or o.curr_cd <> n.curr_cd
                or o.open_acct_org_id <> n.open_acct_org_id
                or o.acct_status_cd <> n.acct_status_cd
                or o.sign_flg <> n.sign_flg
                or o.sign_chn_cd <> n.sign_chn_cd
                or o.hide_flg <> n.hide_flg
                or o.prvlg_open_flg <> n.prvlg_open_flg
                or o.src_sys_cd <> n.src_sys_cd
                or o.fir_bind_tm <> n.fir_bind_tm
                or o.rels_dt <> n.rels_dt
                or o.core_open_tm <> n.core_open_tm
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
from ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm n
    full join ${iml_schema}.agt_tran_bank_acct_tbpsf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_tran_bank_acct truncate partition for ('tbpsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_tran_bank_acct exchange subpartition p_tbpsf1_${batch_date} with table ${iml_schema}.agt_tran_bank_acct_tbpsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_tran_bank_acct drop subpartition p_tbpsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_tran_bank_acct to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_tran_bank_acct_tbpsf1_tm purge;
drop table ${iml_schema}.agt_tran_bank_acct_tbpsf1_ex purge;
drop table ${iml_schema}.agt_tran_bank_acct_tbpsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_tran_bank_acct', partname => 'p_tbpsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);