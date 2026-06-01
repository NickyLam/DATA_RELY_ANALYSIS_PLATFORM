/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_cqss_e_r_bscinf
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
drop table ${iol_schema}.cqss_e_r_bscinf_ex purge;
alter table ${iol_schema}.cqss_e_r_bscinf add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.cqss_e_r_bscinf truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.cqss_e_r_bscinf_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.cqss_e_r_bscinf where 0=1;

insert /*+ append */ into ${iol_schema}.cqss_e_r_bscinf_ex(
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,pbc_cr_ecn_tpcd -- 经济类型 :EC010D01
    ,org_inst_tp -- 组织机构类型 :EC010D02
    ,pbc_cr_entp_sz -- 企业规模 :EC010D03
    ,bliy_cd -- 所属行业 :EC010D04
    ,rgs_adr -- 登记地址 :EC010Q01
    ,fd_yr -- 成立年份 :EC010R01
    ,lc_avldt_codt -- 登记证书有效截止日期 :EC010R02
    ,oprt_adr -- 办公/经营地址 :EC010Q02
    ,pbc_cr_exstn_st -- 存续状态 :EC010D05
    ,cmps_stff_num -- 组成人员个数（主要组成人员个数):EC030S01
    ,cmps_stff_inf_udt_dt -- 组成人员信息更新日期:EC030R01
    ,act_ctrlr_num -- 实际控制人个数:EC050S01
    ,act_ctrlr_inf_udt_dt -- 实际控制人信息更新日期:EC050R01
    ,rgst_cptl -- 注册资本:EC020J01
    ,main_fndd_psn_num -- 主要出资人个数:EC020S01
    ,rgstcptlandmfpifudtdt -- 注册资本及主要出资人信息更新日期:EC020R01
    ,pbc_cr_supr_inst_tp -- 人行征信上级机构类型（上级机构类型):EC040D01
    ,entp_cr_supr_inst_nm -- 企业征信上级机构名称（上级机构名称):EC040Q01
    ,entpsuprinstidntidrtp -- 企业上级机构身份标识类型:EC040D02
    ,supr_inst_idnt_idr_cd -- 上级机构身份标识码:EC040I01
    ,supr_inst_inf_udt_dt -- 上级机构信息更新日期:EC040R01
    ,crt_dt_tm -- 创建日期时间
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    id -- 代码主键
    ,msgidno -- 报文标识号
    ,multi_tenancy_id -- 多实体标识
    ,pbc_cr_ecn_tpcd -- 经济类型 :EC010D01
    ,org_inst_tp -- 组织机构类型 :EC010D02
    ,pbc_cr_entp_sz -- 企业规模 :EC010D03
    ,bliy_cd -- 所属行业 :EC010D04
    ,rgs_adr -- 登记地址 :EC010Q01
    ,fd_yr -- 成立年份 :EC010R01
    ,lc_avldt_codt -- 登记证书有效截止日期 :EC010R02
    ,oprt_adr -- 办公/经营地址 :EC010Q02
    ,pbc_cr_exstn_st -- 存续状态 :EC010D05
    ,cmps_stff_num -- 组成人员个数（主要组成人员个数):EC030S01
    ,cmps_stff_inf_udt_dt -- 组成人员信息更新日期:EC030R01
    ,act_ctrlr_num -- 实际控制人个数:EC050S01
    ,act_ctrlr_inf_udt_dt -- 实际控制人信息更新日期:EC050R01
    ,rgst_cptl -- 注册资本:EC020J01
    ,main_fndd_psn_num -- 主要出资人个数:EC020S01
    ,rgstcptlandmfpifudtdt -- 注册资本及主要出资人信息更新日期:EC020R01
    ,pbc_cr_supr_inst_tp -- 人行征信上级机构类型（上级机构类型):EC040D01
    ,entp_cr_supr_inst_nm -- 企业征信上级机构名称（上级机构名称):EC040Q01
    ,entpsuprinstidntidrtp -- 企业上级机构身份标识类型:EC040D02
    ,supr_inst_idnt_idr_cd -- 上级机构身份标识码:EC040I01
    ,supr_inst_inf_udt_dt -- 上级机构信息更新日期:EC040R01
    ,crt_dt_tm -- 创建日期时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.cqss_e_r_bscinf
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.cqss_e_r_bscinf exchange partition p_${batch_date} with table ${iol_schema}.cqss_e_r_bscinf_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.cqss_e_r_bscinf to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.cqss_e_r_bscinf_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'cqss_e_r_bscinf',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);