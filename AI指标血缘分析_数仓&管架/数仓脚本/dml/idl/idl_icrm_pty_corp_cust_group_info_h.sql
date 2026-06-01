/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_pty_corp_cust_group_info_h
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.icrm_pty_corp_cust_group_info_h drop partition p_${last_date};
alter table ${idl_schema}.icrm_pty_corp_cust_group_info_h drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_pty_corp_cust_group_info_h add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_pty_corp_cust_group_info_h partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,belong_group_id  -- 所属集团编号
    ,data_src_cd  -- 数据来源代码
    ,belong_group_name  -- 所属集团名称
    ,belong_group_orgnz_cd  -- 所属集团组织机构代码
    ,belong_group_loan_card_no  -- 所属集团贷款卡号
    ,belong_group_rgst_cty_rg_cd  -- 所属集团注册国家地区代码
    ,belong_group_site_cd  -- 所属集团所在地代码
    ,belong_group_rgst_addr  -- 所属集团注册地址
    ,group_core_mem_flg  -- 集团核心成员标志
    ,belong_group_dom_work_addr  -- 所属集团国内办公地址
    ,mem_type_cd  -- 成员类型代码
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.belong_group_id,chr(13),''),chr(10),'')  -- 所属集团编号
    ,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'')  -- 数据来源代码
    ,replace(replace(t1.belong_group_name,chr(13),''),chr(10),'')  -- 所属集团名称
    ,replace(replace(t1.belong_group_orgnz_cd,chr(13),''),chr(10),'')  -- 所属集团组织机构代码
    ,replace(replace(t1.belong_group_loan_card_no,chr(13),''),chr(10),'')  -- 所属集团贷款卡号
    ,replace(replace(t1.belong_group_rgst_cty_rg_cd,chr(13),''),chr(10),'')  -- 所属集团注册国家地区代码
    ,replace(replace(t1.belong_group_site_cd,chr(13),''),chr(10),'')  -- 所属集团所在地代码
    ,replace(replace(t1.belong_group_rgst_addr,chr(13),''),chr(10),'')  -- 所属集团注册地址
    ,replace(replace(t1.group_core_mem_flg,chr(13),''),chr(10),'')  -- 集团核心成员标志
    ,replace(replace(t1.belong_group_dom_work_addr,chr(13),''),chr(10),'')  -- 所属集团国内办公地址
    ,replace(replace(t1.mem_type_cd,chr(13),''),chr(10),'')  -- 成员类型代码
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.pty_corp_cust_group_info_h t1    --对公客户集团信息历史
where t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_pty_corp_cust_group_info_h',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);