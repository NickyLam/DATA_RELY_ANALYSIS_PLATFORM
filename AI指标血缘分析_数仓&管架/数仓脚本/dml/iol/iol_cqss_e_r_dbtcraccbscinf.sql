/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_dbtcraccbscinf
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.cqss_e_r_dbtcraccbscinf_ex purge;
alter table ${iol_schema}.cqss_e_r_dbtcraccbscinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_dbtcraccbscinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_dbtcraccbscinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_dbtcraccbscinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_dbtcraccbscinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,dbtcr_acc_id -- 借贷账户编号:ED01AI01
    ,acc_avy_st -- 账户活动状态:ED01AD01
    ,dbtcr_acc_tp -- 借贷账户类型:ED01AD02
    ,lnd_ddln -- 借款期限:ED01AD03
    ,inst_tp -- 机构类型(业务管理机构类型):ED01AD04
    ,mtit_ecd -- 管理机构编码(业务管理机构代码):ED01AI02
    ,crg_agrm_id -- 授信协议编号:ED01AI03
    ,dbtcr_bnctg_lrgclss -- 借贷业务种类大类:ED01AD05
    ,dbtcr_bnctg_sbdvsn -- 借贷业务种类细分:ED01AD06
    ,opnacc_dt -- 开户日期:ED01AR01
    ,ccycd -- 币种代码(币种):ED01AD07
    ,pbc_cr_lnd_amt -- 人行征信借款金额:ED01AJ01
    ,crgln -- 授信额度:ED01AJ02
    ,exdat -- 到期日期:ED01AR02
    ,entp_cr_grtstl -- 企业征信担保方式(担保方式):ED01AD08
    ,dbtcraccorrepygrntmod -- 借贷账户其他还款保证方式(其它还款保证方式):ED01AD09
    ,ln_dstr_form -- 贷款发放形式(发放形式):ED01AD10
    ,jnt_lnd_idr -- 共同借款标识:ED01AD11
    ,cls_dt -- 关闭日期:ED01AR03
    ,infrpt_dt -- 信息报告日期:ED01AR04
    ,repy_prfmn_rcrd_num -- 还款表现记录数:ED01BS01
    ,sptxn_num -- 特定交易个数:ED01CS01
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,dbtcr_acc_id -- 借贷账户编号:ED01AI01
    ,acc_avy_st -- 账户活动状态:ED01AD01
    ,dbtcr_acc_tp -- 借贷账户类型:ED01AD02
    ,lnd_ddln -- 借款期限:ED01AD03
    ,inst_tp -- 机构类型(业务管理机构类型):ED01AD04
    ,mtit_ecd -- 管理机构编码(业务管理机构代码):ED01AI02
    ,crg_agrm_id -- 授信协议编号:ED01AI03
    ,dbtcr_bnctg_lrgclss -- 借贷业务种类大类:ED01AD05
    ,dbtcr_bnctg_sbdvsn -- 借贷业务种类细分:ED01AD06
    ,opnacc_dt -- 开户日期:ED01AR01
    ,ccycd -- 币种代码(币种):ED01AD07
    ,pbc_cr_lnd_amt -- 人行征信借款金额:ED01AJ01
    ,crgln -- 授信额度:ED01AJ02
    ,exdat -- 到期日期:ED01AR02
    ,entp_cr_grtstl -- 企业征信担保方式(担保方式):ED01AD08
    ,dbtcraccorrepygrntmod -- 借贷账户其他还款保证方式(其它还款保证方式):ED01AD09
    ,ln_dstr_form -- 贷款发放形式(发放形式):ED01AD10
    ,jnt_lnd_idr -- 共同借款标识:ED01AD11
    ,cls_dt -- 关闭日期:ED01AR03
    ,infrpt_dt -- 信息报告日期:ED01AR04
    ,repy_prfmn_rcrd_num -- 还款表现记录数:ED01BS01
    ,sptxn_num -- 特定交易个数:ED01CS01
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_dbtcraccbscinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_dbtcraccbscinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_dbtcraccbscinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_dbtcraccbscinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_dbtcraccbscinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_dbtcraccbscinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);