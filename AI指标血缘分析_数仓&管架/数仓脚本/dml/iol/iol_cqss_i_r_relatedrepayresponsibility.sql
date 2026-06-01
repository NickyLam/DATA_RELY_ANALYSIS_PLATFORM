/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_relatedrepayresponsibility
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
drop table ${iol_schema}.cqss_i_r_relatedrepayresponsibility_ex purge;
alter table ${iol_schema}.cqss_i_r_relatedrepayresponsibility add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_relatedrepayresponsibility truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_relatedrepayresponsibility_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_relatedrepayresponsibility where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_relatedrepayresponsibility_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,idnt_inf_cgycd -- 身份信息类别代码:PD03AD08
    ,inst_tp -- 机构类型:PD03AD01
    ,mtit_ecd -- 管理机构编码:PD03AQ01
    ,repy_rspl_bnctg -- 还款责任业务种类:PD03AD02
    ,cr_ln_dstr_dt -- 征信贷款发放日期:PD03AR01
    ,cr_ln_exdat -- 征信贷款到期日期:PD03AR02
    ,rel_repy_rsplpsn_tp -- 相关还款责任人类型:PD03AD03
    ,rel_repy_rspl_qot -- 相关还款责任金额:PD03AJ01
    ,ccycd -- 币种代码:PD03AD04
    ,cr_lnpp_bal -- 征信贷款本金余额:PD03AJ02
    ,pbc_lv5cl_cd -- 人行五级分类代码:PD03AD05
    ,dbtcr_acc_tp -- 借贷账户类型:PD03AD06
    ,cr_ln_repy_st -- 还款状态:PD03AD07
    ,cr_ln_odue_cnu_monum -- 征信贷款逾期持续月数:PD03AS01
    ,vld_codt -- 有效截止日期:PD03AR03
    ,annttn_and_sttmnt_num -- 标注及声明个数
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,grnt_ctr_id -- 保证合同编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,idnt_inf_cgycd -- 身份信息类别代码:PD03AD08
    ,inst_tp -- 机构类型:PD03AD01
    ,mtit_ecd -- 管理机构编码:PD03AQ01
    ,repy_rspl_bnctg -- 还款责任业务种类:PD03AD02
    ,cr_ln_dstr_dt -- 征信贷款发放日期:PD03AR01
    ,cr_ln_exdat -- 征信贷款到期日期:PD03AR02
    ,rel_repy_rsplpsn_tp -- 相关还款责任人类型:PD03AD03
    ,rel_repy_rspl_qot -- 相关还款责任金额:PD03AJ01
    ,ccycd -- 币种代码:PD03AD04
    ,cr_lnpp_bal -- 征信贷款本金余额:PD03AJ02
    ,pbc_lv5cl_cd -- 人行五级分类代码:PD03AD05
    ,dbtcr_acc_tp -- 借贷账户类型:PD03AD06
    ,cr_ln_repy_st -- 还款状态:PD03AD07
    ,cr_ln_odue_cnu_monum -- 征信贷款逾期持续月数:PD03AS01
    ,vld_codt -- 有效截止日期:PD03AR03
    ,annttn_and_sttmnt_num -- 标注及声明个数
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,grnt_ctr_id -- 保证合同编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_relatedrepayresponsibility
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_relatedrepayresponsibility exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_relatedrepayresponsibility_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_relatedrepayresponsibility to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_relatedrepayresponsibility_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_relatedrepayresponsibility',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);