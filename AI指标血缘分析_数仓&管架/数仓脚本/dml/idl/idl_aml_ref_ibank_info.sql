/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_aml_ref_ibank_info
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
alter table ${idl_schema}.aml_ref_ibank_info drop partition p_${last_date};
alter table ${idl_schema}.aml_ref_ibank_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.aml_ref_ibank_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.aml_ref_ibank_info (
    etl_dt  -- 数据日期
    ,ibank_no  -- 联行号
    ,lp_id  -- 法人编号
    ,bank_cls_id  -- 行分类编号
    ,super_prtcpt_bank_no  -- 上级参与行号
    ,super_bank_list  -- 上级行列表
    ,belong_bank_no  -- 所属人行号
    ,prtcpt_type_cd  -- 参与类型代码
    ,bank_type_cd  -- 行别代码
    ,node_cd  -- 节点代码
    ,rg_cd  -- 地区代码
    ,status_cd  -- 状态代码
    ,bank_fname  -- 银行全称
    ,bank_abbr  -- 银行简称
    ,phys_addr  -- 物理地址
    ,zip_cd  -- 邮政编码
    ,tel_num  -- 电话号码
    ,elec_addr  -- 电子地址
    ,effect_dt  -- 生效日期
    ,invalid_dt  -- 失效日期
    ,cert_bind_cn_region  -- 证书绑定CN域
    ,cert_bind_sn_region  -- 证书绑定SN域
    ,cert_bind_status  -- 证书绑定状态
    ,cert_bind_effect_dt  -- 证书绑定生效日期
    ,cert_bind_invalid_dt  -- 证书绑定失效日期
    ,final_modif_operr_id  -- 最后修改操作员编号
    ,final_update_tm  -- 最后更新时间
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.ibank_no,chr(13),''),chr(10),'')  -- 联行号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.bank_cls_id,chr(13),''),chr(10),'')  -- 行分类编号
    ,replace(replace(t1.super_prtcpt_bank_no,chr(13),''),chr(10),'')  -- 上级参与行号
    ,replace(replace(t1.super_bank_list,chr(13),''),chr(10),'')  -- 上级行列表
    ,replace(replace(t1.belong_bank_no,chr(13),''),chr(10),'')  -- 所属人行号
    ,replace(replace(t1.prtcpt_type_cd,chr(13),''),chr(10),'')  -- 参与类型代码
    ,replace(replace(t1.bank_type_cd,chr(13),''),chr(10),'')  -- 行别代码
    ,replace(replace(t1.node_cd,chr(13),''),chr(10),'')  -- 节点代码
    ,replace(replace(t1.rg_cd,chr(13),''),chr(10),'')  -- 地区代码
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,replace(replace(t1.bank_fname,chr(13),''),chr(10),'')  -- 银行全称
    ,replace(replace(t1.bank_abbr,chr(13),''),chr(10),'')  -- 银行简称
    ,replace(replace(t1.phys_addr,chr(13),''),chr(10),'')  -- 物理地址
    ,replace(replace(t1.zip_cd,chr(13),''),chr(10),'')  -- 邮政编码
    ,replace(replace(t1.tel_num,chr(13),''),chr(10),'')  -- 电话号码
    ,replace(replace(t1.elec_addr,chr(13),''),chr(10),'')  -- 电子地址
    ,t1.effect_dt  -- 生效日期
    ,t1.invalid_dt  -- 失效日期
    ,replace(replace(t1.cert_bind_cn_region,chr(13),''),chr(10),'')  -- 证书绑定CN域
    ,replace(replace(t1.cert_bind_sn_region,chr(13),''),chr(10),'')  -- 证书绑定SN域
    ,replace(replace(t1.cert_bind_status,chr(13),''),chr(10),'')  -- 证书绑定状态
    ,t1.cert_bind_effect_dt  -- 证书绑定生效日期
    ,t1.cert_bind_invalid_dt  -- 证书绑定失效日期
    ,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'')  -- 最后修改操作员编号
    ,t1.final_update_tm  -- 最后更新时间
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.ref_ibank_info t1    --联行信息
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'aml_ref_ibank_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);