/*
Purpose:    技术缓冲层脚本，把数据文件加载到目标表的当天分区中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd itl_itl_edw_cmm_dep_oc_acct_dtl
CreateDate: 20220418
Logs:
    郑沛隆 2022-04-18 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
--alter table ${itl_schema}.itl_edw_cmm_dep_oc_acct_dtl drop partition p_${retain_day};
alter table ${itl_schema}.itl_edw_cmm_dep_oc_acct_dtl drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${itl_schema}.itl_edw_cmm_dep_oc_acct_dtl add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${itl_schema}.itl_edw_cmm_dep_oc_acct_dtl partition for (to_date('${batch_date}','yyyymmdd')) (
    lp_id -- 法人编号
    ,oc_acct_flow_num -- 开销户流水号
    ,ova_chn_flow_num -- 全局渠道流水号
    ,tran_flow_num -- 交易流水号
    ,tran_dt -- 交易日期
    ,acct_id -- 账户编号
    ,sub_acct_id -- 子户编号
    ,acct_name -- 账户名称
    ,open_vouch_id -- 开户凭证编号
    ,dep_prod_acct_id -- 存款产品户编号
    ,belong_org_id -- 归属机构编号
    ,tran_org_id -- 交易机构编号
    ,sav_type_cd -- 储种代码
    ,dep_term_cd -- 存期代码
    ,open_vouch_type_cd -- 开户凭证类型代码
    ,proc_status_cd -- 处理状态代码
    ,chn_cd -- 渠道代码
    ,curr_cd -- 币种代码
    ,operr_cert_type_cd -- 经办人证件类型代码
    ,operr_cert_no -- 经办人证件号
    ,operr_mobile_no -- 经办人手机号
    ,operr_info_invalid_dt -- 经办人信息失效日期
    ,ec_flg -- 钞汇标志
    ,oc_acct_flg -- 开销户标志
    ,strk_bal_flg -- 冲账标志
    ,tran_amt -- 交易金额
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间
)
select
    nvl(trim(lp_id), ' ') as lp_id -- 法人编号
    ,nvl(trim(oc_acct_flow_num), ' ') as oc_acct_flow_num -- 开销户流水号
    ,nvl(trim(ova_chn_flow_num), ' ') as ova_chn_flow_num -- 全局渠道流水号
    ,nvl(trim(tran_flow_num), ' ') as tran_flow_num -- 交易流水号
    ,nvl(tran_dt, to_date('00010101', 'yyyymmdd')) as tran_dt -- 交易日期
    ,nvl(trim(acct_id), ' ') as acct_id -- 账户编号
    ,nvl(trim(sub_acct_id), ' ') as sub_acct_id -- 子户编号
    ,nvl(trim(acct_name), ' ') as acct_name -- 账户名称
    ,nvl(trim(open_vouch_id), ' ') as open_vouch_id -- 开户凭证编号
    ,nvl(trim(dep_prod_acct_id), ' ') as dep_prod_acct_id -- 存款产品户编号
    ,nvl(trim(belong_org_id), ' ') as belong_org_id -- 归属机构编号
    ,nvl(trim(tran_org_id), ' ') as tran_org_id -- 交易机构编号
    ,nvl(trim(sav_type_cd), ' ') as sav_type_cd -- 储种代码
    ,nvl(trim(dep_term_cd), ' ') as dep_term_cd -- 存期代码
    ,nvl(trim(open_vouch_type_cd), ' ') as open_vouch_type_cd -- 开户凭证类型代码
    ,nvl(trim(proc_status_cd), ' ') as proc_status_cd -- 处理状态代码
    ,nvl(trim(chn_cd), ' ') as chn_cd -- 渠道代码
    ,nvl(trim(curr_cd), ' ') as curr_cd -- 币种代码
    ,nvl(trim(operr_cert_type_cd), ' ') as operr_cert_type_cd -- 经办人证件类型代码
    ,nvl(trim(operr_cert_no), ' ') as operr_cert_no -- 经办人证件号
    ,nvl(trim(operr_mobile_no), ' ') as operr_mobile_no -- 经办人手机号
    ,nvl(operr_info_invalid_dt, to_date('00010101', 'yyyymmdd')) as operr_info_invalid_dt -- 经办人信息失效日期
    ,nvl(trim(ec_flg), ' ') as ec_flg -- 钞汇标志
    ,nvl(trim(oc_acct_flg), ' ') as oc_acct_flg -- 开销户标志
    ,nvl(trim(strk_bal_flg), ' ') as strk_bal_flg -- 冲账标志
    ,nvl(trim(tran_amt), 0) as tran_amt -- 交易金额
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${msl_schema}.msl_edw_cmm_dep_oc_acct_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')
 ;
commit;

-- 3 table grant
whenever sqlerror exit sql.sqlcode;
grant select on ${itl_schema}.itl_edw_cmm_dep_oc_acct_dtl to ${iol_schema};

-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${itl_schema}',tabname => 'itl_edw_cmm_dep_oc_acct_dtl',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);