/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_icrm_org_ibank_org
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
alter table ${idl_schema}.icrm_org_ibank_org drop partition p_${last_date};
alter table ${idl_schema}.icrm_org_ibank_org drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.icrm_org_ibank_org add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.icrm_org_ibank_org partition for (to_date('${batch_date}','yyyymmdd')) (
    etl_dt  -- 数据日期
    ,org_id  -- 机构编号
    ,lp_id  -- 法人编号
    ,intnal_org_id  -- 内部机构编号
    ,org_name  -- 机构名称
    ,org_fname  -- 机构全称
    ,org_alias  -- 机构别名
    ,org_pinyin  -- 机构拼音
    ,org_status_cd  -- 机构状态代码
    ,org_cls_cd  -- 机构分类代码
    ,prod_type_cd  -- 产品类型代码
    ,found_dt  -- 成立日期
    ,bus_lics  -- 营业执照
    ,org_cd_cert  -- 机构代码证
    ,fin_lics  -- 金融许可证
    ,dc_cnaps_sys_bank_no  -- 本币现代支付系统行号
    ,fcurr_cnaps_sys_bank_no  -- 外币现代支付系统行号
    ,update_user_id  -- 更新用户编号
    ,h_update_dt  -- 历史更新日期
    ,h_update_tm  -- 历史更新时间
    ,rgst_land  -- 注册地
    ,imp_chn  -- 导入渠道
    ,imp_dt  -- 导入日期
    ,core_cust_no  -- 核心客户号
    ,cust_cls  -- 客户分类
    ,org_hibchy_cd  -- 机构层级代码
    ,matn_org_id  -- 维护机构编号
    ,matn_org_name  -- 维护机构名称
    ,cust_type_cd  -- 客户类型代码
    ,mar_maker_flg  -- 做市商标志
    ,effect_flg  -- 生效标志
    ,en_name  -- 英文名称
    ,en_fname  -- 英文全称
    ,spv_asset_flg  -- SPV资产标志
    ,job_cd  -- 任务代码
    ,etl_timestamp  -- 数据处理时间
)
select
    to_date('${batch_date}','yyyymmdd') as etl_dt  -- 数据日期
    ,replace(replace(t1.org_id,chr(13),''),chr(10),'')  -- 机构编号
    ,replace(replace(t1.lp_id,chr(13),''),chr(10),'')  -- 法人编号
    ,replace(replace(t1.intnal_org_id,chr(13),''),chr(10),'')  -- 内部机构编号
    ,replace(replace(t1.org_name,chr(13),''),chr(10),'')  -- 机构名称
    ,replace(replace(t1.org_fname,chr(13),''),chr(10),'')  -- 机构全称
    ,replace(replace(t1.org_alias,chr(13),''),chr(10),'')  -- 机构别名
    ,replace(replace(t1.org_pinyin,chr(13),''),chr(10),'')  -- 机构拼音
    ,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'')  -- 机构状态代码
    ,replace(replace(t1.org_cls_cd,chr(13),''),chr(10),'')  -- 机构分类代码
    ,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'')  -- 产品类型代码
    ,t1.found_dt  -- 成立日期
    ,replace(replace(t1.bus_lics,chr(13),''),chr(10),'')  -- 营业执照
    ,replace(replace(t1.org_cd_cert,chr(13),''),chr(10),'')  -- 机构代码证
    ,replace(replace(t1.fin_lics,chr(13),''),chr(10),'')  -- 金融许可证
    ,replace(replace(t1.dc_cnaps_sys_bank_no,chr(13),''),chr(10),'')  -- 本币现代支付系统行号
    ,replace(replace(t1.fcurr_cnaps_sys_bank_no,chr(13),''),chr(10),'')  -- 外币现代支付系统行号
    ,replace(replace(t1.update_user_id,chr(13),''),chr(10),'')  -- 更新用户编号
    ,t1.h_update_dt  -- 历史更新日期
    ,replace(replace(t1.h_update_tm,chr(13),''),chr(10),'')  -- 历史更新时间
    ,replace(replace(t1.rgst_land,chr(13),''),chr(10),'')  -- 注册地
    ,replace(replace(t1.imp_chn,chr(13),''),chr(10),'')  -- 导入渠道
    ,t1.imp_dt  -- 导入日期
    ,replace(replace(t1.core_cust_no,chr(13),''),chr(10),'')  -- 核心客户号
    ,replace(replace(t1.cust_cls,chr(13),''),chr(10),'')  -- 客户分类
    ,replace(replace(t1.org_hibchy_cd,chr(13),''),chr(10),'')  -- 机构层级代码
    ,replace(replace(t1.matn_org_id,chr(13),''),chr(10),'')  -- 维护机构编号
    ,replace(replace(t1.matn_org_name,chr(13),''),chr(10),'')  -- 维护机构名称
    ,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'')  -- 客户类型代码
    ,replace(replace(t1.mar_maker_flg,chr(13),''),chr(10),'')  -- 做市商标志
    ,replace(replace(t1.effect_flg,chr(13),''),chr(10),'')  -- 生效标志
    ,replace(replace(t1.en_name,chr(13),''),chr(10),'')  -- 英文名称
    ,replace(replace(t1.en_fname,chr(13),''),chr(10),'')  -- 英文全称
    ,replace(replace(t1.spv_asset_flg,chr(13),''),chr(10),'')  -- SPV资产标志
    ,replace(replace(t1.job_cd,chr(13),''),chr(10),'')  -- 任务代码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp   --数据处理时间
from ${iml_schema}.org_ibank_org t1    --同业机构
where t1.create_dt<= to_date('${batch_date}','yyyymmdd') and t1.id_mark <> 'D' ;
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'icrm_org_ibank_org',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);