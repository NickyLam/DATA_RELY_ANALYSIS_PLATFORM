/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_creditsummary
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
drop table ${iol_schema}.cqss_i_r_creditsummary_ex purge;
alter table ${iol_schema}.cqss_i_r_creditsummary add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_creditsummary truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_creditsummary_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_creditsummary where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_creditsummary_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,pbc_digt_iptn -- 人行数字解读
    ,rel_lo -- 相对位置
    ,scor_cmnt_num -- 分数说明条数
    ,crln_acc_tot -- 信贷账户数合计:PC02AS01
    ,crbn_tp_num -- 信贷业务类型数量:PC02AS02
    ,be_rec_acc_tot -- 被追偿账户数合计:PC02BS01
    ,be_rec_bal_tot -- 被追偿余额合计:PC02BJ01
    ,be_rec_btp_num -- 被追偿业务类型数量:PC02BS02
    ,stgdbt_acc -- 呆账账户数:PC02CS01
    ,stgdbt_bal -- 呆账余额:PC02CJ01
    ,odue_od_btp_num -- 逾期透支业务类型数量:PC02DS01
    ,rel_repy_rspl_num -- 相关还款责任个数:PC02KS01
    ,af_py_btp_num -- 后付费业务类型数量:PC030S01
    ,pblc_inf_tp_num -- 公共信息类型数量:PC040S01
    ,lt_enqr_dt -- 上一次查询日期:PC05AR01
    ,lt_enqr_inst_tp -- 上一次查询机构类型:PC05AD01
    ,lt_enqr_inst_cd -- 上一次查询机构代码:PC05AI01
    ,lt_enqr_rsn -- 上一次查询原因:PC05AQ01
    ,lnaprvrcy1emieinstnum -- 贷款审批最近1个月内的查询机构数:PC05BS01
    ,ccarcy1emienqrinstnum -- 信用卡审批最近1个月内的查询机构数:PC05BS02
    ,lnaprvrcly1emienqrcnt -- 贷款审批最近1个月内的查询次数:PC05BS03
    ,ccarcy1eminnrsenqrcnt -- 信用卡审批最近1个月内的查询次数:PC05BS04
    ,myslfenqrr1emienqrcnt -- 本人查询最近1个月内的查询次数:PC05BS05
    ,pstloanmgtr2yienqrcnt -- 贷后管理最近2年内的查询次数:PC05BS06
    ,wrntquaexmr2yienqrcnt -- 担保资格审查最近2年内的查询次数:PC05BS07
    ,apntmrchrner2yienrcnt -- 特约商户实名审查最近2年内的查询次数:PC05BS08
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,pbc_digt_iptn -- 人行数字解读
    ,rel_lo -- 相对位置
    ,scor_cmnt_num -- 分数说明条数
    ,crln_acc_tot -- 信贷账户数合计:PC02AS01
    ,crbn_tp_num -- 信贷业务类型数量:PC02AS02
    ,be_rec_acc_tot -- 被追偿账户数合计:PC02BS01
    ,be_rec_bal_tot -- 被追偿余额合计:PC02BJ01
    ,be_rec_btp_num -- 被追偿业务类型数量:PC02BS02
    ,stgdbt_acc -- 呆账账户数:PC02CS01
    ,stgdbt_bal -- 呆账余额:PC02CJ01
    ,odue_od_btp_num -- 逾期透支业务类型数量:PC02DS01
    ,rel_repy_rspl_num -- 相关还款责任个数:PC02KS01
    ,af_py_btp_num -- 后付费业务类型数量:PC030S01
    ,pblc_inf_tp_num -- 公共信息类型数量:PC040S01
    ,lt_enqr_dt -- 上一次查询日期:PC05AR01
    ,lt_enqr_inst_tp -- 上一次查询机构类型:PC05AD01
    ,lt_enqr_inst_cd -- 上一次查询机构代码:PC05AI01
    ,lt_enqr_rsn -- 上一次查询原因:PC05AQ01
    ,lnaprvrcy1emieinstnum -- 贷款审批最近1个月内的查询机构数:PC05BS01
    ,ccarcy1emienqrinstnum -- 信用卡审批最近1个月内的查询机构数:PC05BS02
    ,lnaprvrcly1emienqrcnt -- 贷款审批最近1个月内的查询次数:PC05BS03
    ,ccarcy1eminnrsenqrcnt -- 信用卡审批最近1个月内的查询次数:PC05BS04
    ,myslfenqrr1emienqrcnt -- 本人查询最近1个月内的查询次数:PC05BS05
    ,pstloanmgtr2yienqrcnt -- 贷后管理最近2年内的查询次数:PC05BS06
    ,wrntquaexmr2yienqrcnt -- 担保资格审查最近2年内的查询次数:PC05BS07
    ,apntmrchrner2yienrcnt -- 特约商户实名审查最近2年内的查询次数:PC05BS08
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_creditsummary
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_creditsummary exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_creditsummary_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_creditsummary to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_creditsummary_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_creditsummary',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);