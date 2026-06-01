/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_pty_ibank_cntpty_info
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
alter table ${idl_schema}.icrm_pty_ibank_cntpty_info drop partition p_${last_date};
alter table ${idl_schema}.icrm_pty_ibank_cntpty_info drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_pty_ibank_cntpty_info add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_pty_ibank_cntpty_info (
    etl_dt  -- 数据日期
    ,party_id  -- 当事人编号
    ,lp_id  -- 法人编号
    ,src_party_id  -- 源当事人编号
    ,org_id  -- 机构编号
    ,super_org_id  -- 上级机构编号
    ,party_name  -- 当事人名称
    ,party_fname  -- 当事人全称
    ,party_alias  -- 当事人别名
    ,party_pinyin  -- 当事人拼音
    ,en_name  -- 英文名称
    ,en_fname  -- 英文全称
    ,status_cd  -- 状态代码
    ,found_dt  -- 成立日期
    ,bus_lics_num  -- 营业执照号码
    ,party_cd_cert_id  -- 当事人代码证编号
    ,fin_lics_id  -- 金融许可证编号
    ,dc_pay_sys_bank_no  -- 本币支付系统行号
    ,fcurr_pay_sys_bank_no  -- 外币支付系统行号
    ,rgst  -- 注册地
    ,party_cls_descb  -- 当事人分类描述
    ,party_type_cd  -- 当事人类型代码
    ,cust_id  -- 客户编号
    ,mar_maker_flg  -- 做市商标志
    ,spv_flg  -- SPV标志
    ,matn_org_id  -- 维护机构编号
    ,matn_org_name  -- 维护机构名称
    ,create_dt  -- 创建日期
    ,update_dt  -- 更新日期
    ,id_mark  -- 删除标识
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.party_id,chr(13),''),chr(10),'')  -- 当事人编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.src_party_id,chr(13),''),chr(10),'')  -- 源当事人编号
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.super_org_id,chr(13),''),chr(10),'')  -- 上级机构编号
    ,replace(replace(t1.party_name,chr(13),''),chr(10),'')  -- 当事人名称
    ,replace(replace(t1.party_fname,chr(13),''),chr(10),'')  -- 当事人全称
    ,replace(replace(t1.party_alias,chr(13),''),chr(10),'')  -- 当事人别名
    ,replace(replace(t1.party_pinyin,chr(13),''),chr(10),'')  -- 当事人拼音
    ,replace(replace(t1.en_name,chr(13),''),chr(10),'')  -- 英文名称
    ,replace(replace(t1.en_fname,chr(13),''),chr(10),'')  -- 英文全称
    ,replace(replace(t1.status_cd,chr(13),''),chr(10),'')  -- 状态代码
    ,t1.found_dt  -- 成立日期
    ,replace(replace(t1.bus_lics_num,chr(13),''),chr(10),'')  -- 营业执照号码
    ,replace(replace(t1.party_cd_cert_id,chr(13),''),chr(10),'')  -- 当事人代码证编号
    ,replace(replace(t1.fin_lics_id,chr(13),''),chr(10),'')  -- 金融许可证编号
    ,replace(replace(t1.dc_pay_sys_bank_no,chr(13),''),chr(10),'')  -- 本币支付系统行号
    ,replace(replace(t1.fcurr_pay_sys_bank_no,chr(13),''),chr(10),'')  -- 外币支付系统行号
    ,replace(replace(t1.rgst,chr(13),''),chr(10),'')  -- 注册地
    ,replace(replace(t1.party_cls_descb,chr(13),''),chr(10),'')  -- 当事人分类描述
    ,replace(replace(t1.party_type_cd,chr(13),''),chr(10),'')  -- 当事人类型代码
    ,replace(replace(t1.cust_id,chr(13),''),chr(10),'')  -- 客户编号
    ,replace(replace(t1.mar_maker_flg,chr(13),''),chr(10),'')  -- 做市商标志
    ,replace(replace(t1.spv_flg,chr(13),''),chr(10),'')  -- SPV标志
    ,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'')  -- 维护机构编号
    ,replace(replace(t1.matn_org_name,chr(13),''),chr(10),'')  -- 维护机构名称
    ,t1.create_dt  -- 创建日期
    ,t1.update_dt  -- 更新日期
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'')  -- 删除标识
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp  -- 数据处理时间
from ${iml_schema}.pty_ibank_cntpty_info t1    --同业交易对手信息
where t1.create_dt <= to_date('${batch_date}','yyyymmdd') ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_pty_ibank_cntpty_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);