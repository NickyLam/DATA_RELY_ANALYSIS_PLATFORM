/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_i_r_messageheader
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
drop table ${iol_schema}.cqss_i_r_messageheader_ex purge;
alter table ${iol_schema}.cqss_i_r_messageheader add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_i_r_messageheader truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_i_r_messageheader_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_i_r_messageheader where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_i_r_messageheader_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,idv_cr_rpt_file_id -- 个人征信报告文件编号:PA01AI01
    ,msgrp_gen_tm -- 报文生成时间:PA01AR01
    ,cr_enqd_ppl_nm -- 征信被查询者姓名:PA01BQ01
    ,pbc_tngncr_pts_tpcd -- 人行二代证件类型代码:PA01BD01
    ,crrptenqd_psn_crdt_no -- 信用报告被查询人证件号码:PA01BI01
    ,cr_enqd_insid -- 征信被查询机构编号:PA01BI02
    ,pbc_enqr_rscd -- 人行查询原因代码:PA01BD02
    ,crdt_inf_rcrd_num -- 证件信息记录数:PA01CS01
    ,cht_ind -- 欺诈标志:PA01DQ01
    ,ctc_tel -- 联系电话:PA01DQ02
    ,afrd_strtg_rlsdt_prd -- 反欺诈策略发布日期:PA01DR01
    ,afrd_strtg_expdt -- 反欺诈策略失效日期:PA01DR02
    ,cr_objtn_num -- 征信异议数目:PA01ES01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,idv_cr_rpt_file_id -- 个人征信报告文件编号:PA01AI01
    ,msgrp_gen_tm -- 报文生成时间:PA01AR01
    ,cr_enqd_ppl_nm -- 征信被查询者姓名:PA01BQ01
    ,pbc_tngncr_pts_tpcd -- 人行二代证件类型代码:PA01BD01
    ,crrptenqd_psn_crdt_no -- 信用报告被查询人证件号码:PA01BI01
    ,cr_enqd_insid -- 征信被查询机构编号:PA01BI02
    ,pbc_enqr_rscd -- 人行查询原因代码:PA01BD02
    ,crdt_inf_rcrd_num -- 证件信息记录数:PA01CS01
    ,cht_ind -- 欺诈标志:PA01DQ01
    ,ctc_tel -- 联系电话:PA01DQ02
    ,afrd_strtg_rlsdt_prd -- 反欺诈策略发布日期:PA01DR01
    ,afrd_strtg_expdt -- 反欺诈策略失效日期:PA01DR02
    ,cr_objtn_num -- 征信异议数目:PA01ES01
    ,multi_tenancy_id -- 多实体标识
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_i_r_messageheader
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_i_r_messageheader exchange partition p_${batch_date} with table ${iol_schema}.cqss_i_r_messageheader_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_i_r_messageheader to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_i_r_messageheader_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_i_r_messageheader',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);