/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_pty_tmss_group_cust
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
--alter table ${idl_schema}.pty_tmss_group_cust drop partition p_${last_date};
alter table ${idl_schema}.pty_tmss_group_cust drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.pty_tmss_group_cust add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.pty_tmss_group_cust (
    etl_dt  -- 数据日期
    ,cust_id  -- 客户编号
    ,lp_id  -- 法人编号
    ,party_id  -- 当事人编号
    ,cust_name  -- 客户名称
    ,cert_cate_cd  -- 证件类别代码
    ,cert_type_cd  -- 证件类型代码
    ,cert_no  -- 证件号码
    ,group_type_cd  -- 集团类型代码
    ,multi_bank_serv_flg  -- 多银行服务标志
    ,open_bank_no  -- 开户行行号
    ,belong_bank_no  -- 归属行行号
    ,status_cd  -- 状态代码
    ,operr_id  -- 操作人编号
    ,create_tm  -- 创建时间
    ,checker_id  -- 复核人编号
    ,check_tm  -- 复核时间
    ,group_id  -- 集团编号
    ,unify_soci_crdt_id  -- 统一社会信用编号
    ,adres_name  -- 收件人名称
    ,adres_addr  -- 收件人地址
    ,adres_tel  -- 收件人电话
    ,adres_remark  -- 收件人备注
    ,dc_rgst_status_cd  -- 软证书注册状态代码
    ,dc_valid_tm  -- 软证书有效时间
    ,ukey_uplmi_cnt  -- ukey上限数
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd -- 任务编码

)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.cust_name,chr(13),''),chr(10),'')  -- 客户名称
    ,replace(replace(t1.cert_cate_cd,chr(13),''),chr(10),'')  -- 证件类别代码
    ,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'')  -- 证件类型代码
    ,replace(replace(t1.cert_no,chr(13),''),chr(10),'')  -- 证件号码
    ,replace(replace(t1.group_type_cd,chr(13),''),chr(10),'')  -- 集团类型代码
    ,replace(replace(t1.multi_bank_serv_flg,chr(13),''),chr(10),'')  -- 多银行服务标志
    ,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'')  -- 开户行行号
    ,replace(replace(t1.belong_bank_no,chr(13),''),chr(10),'')  -- 归属行行号
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,replace(replace(t1.operr_id,chr(13),''),chr(10),'')  -- 操作人编号
    ,t1.create_tm  -- 创建时间
    ,replace(replace(t1.checker_id,chr(13),''),chr(10),'')  -- 复核人编号
    ,t1.check_tm  -- 复核时间
    ,replace(replace(t1.group_id,chr(13),''),chr(10),'')  -- 集团编号
    ,replace(replace(t1.unify_soci_crdt_id,chr(13),''),chr(10),'')  -- 统一社会信用编号
    ,replace(replace(t1.adres_name,chr(13),''),chr(10),'')  -- 收件人名称
    ,replace(replace(t1.adres_addr,chr(13),''),chr(10),'')  -- 收件人地址
    ,replace(replace(t1.adres_tel,chr(13),''),chr(10),'')  -- 收件人电话
    ,replace(replace(t1.adres_remark,chr(13),''),chr(10),'')  -- 收件人备注
    ,replace(replace(t1.dc_rgst_status_cd,chr(13),''),chr(10),'')  -- 软证书注册状态代码
    ,t1.dc_valid_tm  -- 软证书有效时间
    ,t1.ukey_uplmi_cnt  -- ukey上限数
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务编码

from ${iml_schema}.pty_tmss_group_cust t1    --现金管理集团客户
;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'pty_tmss_group_cust',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);