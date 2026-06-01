/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_org_ibank_org_ibmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.org_ibank_org_ibmsf1_tm purge;
drop table ${iml_schema}.org_ibank_org_ibmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.org_ibank_org add partition p_ibmsf1 values ('ibmsf1')(
        subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.org_ibank_org modify partition p_ibmsf1
    add subpartition p_ibmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.org_ibank_org_ibmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.org_ibank_org partition for ('ibmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.org_ibank_org_ibmsf1_tm
compress ${option_switch} for query high
as
select
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,intnal_org_id -- 内部机构编号
    ,org_name -- 机构名称
    ,org_fname -- 机构全称
    ,org_alias -- 机构别名
    ,org_pinyin -- 机构拼音
    ,org_status_cd -- 机构状态代码
    ,org_cls_cd -- 机构分类代码
    ,prod_type_cd -- 产品类型代码
    ,found_dt -- 成立日期
    ,bus_lics -- 营业执照
    ,org_cd_cert -- 机构代码证
    ,fin_lics -- 金融许可证
    ,dc_cnaps_sys_bank_no -- 本币现代支付系统行号
    ,fcurr_cnaps_sys_bank_no -- 外币现代支付系统行号
    ,update_user_id -- 更新用户编号
    ,h_update_dt -- 历史更新日期
    ,h_update_tm -- 历史更新时间
    ,rgst_land -- 注册地
    ,imp_chn -- 导入渠道
    ,imp_dt -- 导入日期
    ,core_cust_no -- 核心客户号
    ,cust_cls -- 客户分类
    ,org_hibchy_cd -- 机构层级代码
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,cust_type_cd -- 客户类型代码
    ,mar_maker_flg -- 做市商标志
    ,effect_flg -- 生效标志
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,spv_asset_flg -- SPV资产标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_ibank_org
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.org_ibank_org_ibmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.org_ibank_org partition for ('ibmsf1') where 0=1;

-- 2.1 insert data to tm table
-- ibms_ttrd_institution-
insert into ${iml_schema}.org_ibank_org_ibmsf1_tm(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,intnal_org_id -- 内部机构编号
    ,org_name -- 机构名称
    ,org_fname -- 机构全称
    ,org_alias -- 机构别名
    ,org_pinyin -- 机构拼音
    ,org_status_cd -- 机构状态代码
    ,org_cls_cd -- 机构分类代码
    ,prod_type_cd -- 产品类型代码
    ,found_dt -- 成立日期
    ,bus_lics -- 营业执照
    ,org_cd_cert -- 机构代码证
    ,fin_lics -- 金融许可证
    ,dc_cnaps_sys_bank_no -- 本币现代支付系统行号
    ,fcurr_cnaps_sys_bank_no -- 外币现代支付系统行号
    ,update_user_id -- 更新用户编号
    ,h_update_dt -- 历史更新日期
    ,h_update_tm -- 历史更新时间
    ,rgst_land -- 注册地
    ,imp_chn -- 导入渠道
    ,imp_dt -- 导入日期
    ,core_cust_no -- 核心客户号
    ,cust_cls -- 客户分类
    ,org_hibchy_cd -- 机构层级代码
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,cust_type_cd -- 客户类型代码
    ,mar_maker_flg -- 做市商标志
    ,effect_flg -- 生效标志
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,spv_asset_flg -- SPV资产标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.I_ID -- 机构编号
    ,'9999' -- 法人编号
    ,P1.ORG_ID -- 内部机构编号
    ,P1.I_NAME -- 机构名称
    ,P1.I_FULLNAME -- 机构全称
    ,P1.I_ALIAS -- 机构别名
    ,P1.PY_CODE -- 机构拼音
    ,P1.STATUS -- 机构状态代码
    ,P1.T_CODE -- 机构分类代码
    ,P1.P_TYPE -- 产品类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.ONLINE_DATE) -- 成立日期
    ,P1.I_BUSINESS_LICENSE -- 营业执照
    ,P1.I_LR_INST_CODE -- 机构代码证
    ,P1.I_FINANCIAL_LICENSE -- 金融许可证
    ,P1.CNAPS_CODE -- 本币现代支付系统行号
    ,P1.SWIFT_CODE -- 外币现代支付系统行号
    ,P1.UPDATE_USER -- 更新用户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.UPDATE_DATE) -- 历史更新日期
    ,P1.UPDATE_TIME -- 历史更新时间
    ,P1.BELONG_TO_AREA -- 注册地
    ,P1.PIPE_ID -- 导入渠道
    ,${iml_schema}.DATEFORMAT_MIN(P1.IMP_DATE) -- 导入日期
    ,P1.CORE_SYS_CUSTOMER_CODE -- 核心客户号
    ,P1.T_PATH -- 客户分类
    ,NVL(P1.I_LEVEL,'-') -- 机构层级代码
    ,P1.EDIT_IID -- 维护机构编号
    ,P1.EDIT_INAME -- 维护机构名称
    ,P1.INST_CLASS -- 客户类型代码
    ,P1.IS_MARKET_MAKER -- 做市商标志
    ,NVL(P1.REV_STATE,'-') -- 生效标志
    ,P1.EN_NAME -- 英文名称
    ,P1.EN_FULLNAME -- 英文全称
    ,P1.IS_SPV -- SPV资产标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ibms_ttrd_institution' -- 源表名称
    ,'ibmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ibms_ttrd_institution p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.org_ibank_org_ibmsf1_ex(
    org_id -- 机构编号
    ,lp_id -- 法人编号
    ,intnal_org_id -- 内部机构编号
    ,org_name -- 机构名称
    ,org_fname -- 机构全称
    ,org_alias -- 机构别名
    ,org_pinyin -- 机构拼音
    ,org_status_cd -- 机构状态代码
    ,org_cls_cd -- 机构分类代码
    ,prod_type_cd -- 产品类型代码
    ,found_dt -- 成立日期
    ,bus_lics -- 营业执照
    ,org_cd_cert -- 机构代码证
    ,fin_lics -- 金融许可证
    ,dc_cnaps_sys_bank_no -- 本币现代支付系统行号
    ,fcurr_cnaps_sys_bank_no -- 外币现代支付系统行号
    ,update_user_id -- 更新用户编号
    ,h_update_dt -- 历史更新日期
    ,h_update_tm -- 历史更新时间
    ,rgst_land -- 注册地
    ,imp_chn -- 导入渠道
    ,imp_dt -- 导入日期
    ,core_cust_no -- 核心客户号
    ,cust_cls -- 客户分类
    ,org_hibchy_cd -- 机构层级代码
    ,matn_org_id -- 维护机构编号
    ,matn_org_name -- 维护机构名称
    ,cust_type_cd -- 客户类型代码
    ,mar_maker_flg -- 做市商标志
    ,effect_flg -- 生效标志
    ,en_name -- 英文名称
    ,en_fname -- 英文全称
    ,spv_asset_flg -- SPV资产标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.intnal_org_id, o.intnal_org_id) as intnal_org_id -- 内部机构编号
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.org_fname, o.org_fname) as org_fname -- 机构全称
    ,nvl(n.org_alias, o.org_alias) as org_alias -- 机构别名
    ,nvl(n.org_pinyin, o.org_pinyin) as org_pinyin -- 机构拼音
    ,nvl(n.org_status_cd, o.org_status_cd) as org_status_cd -- 机构状态代码
    ,nvl(n.org_cls_cd, o.org_cls_cd) as org_cls_cd -- 机构分类代码
    ,nvl(n.prod_type_cd, o.prod_type_cd) as prod_type_cd -- 产品类型代码
    ,nvl(n.found_dt, o.found_dt) as found_dt -- 成立日期
    ,nvl(n.bus_lics, o.bus_lics) as bus_lics -- 营业执照
    ,nvl(n.org_cd_cert, o.org_cd_cert) as org_cd_cert -- 机构代码证
    ,nvl(n.fin_lics, o.fin_lics) as fin_lics -- 金融许可证
    ,nvl(n.dc_cnaps_sys_bank_no, o.dc_cnaps_sys_bank_no) as dc_cnaps_sys_bank_no -- 本币现代支付系统行号
    ,nvl(n.fcurr_cnaps_sys_bank_no, o.fcurr_cnaps_sys_bank_no) as fcurr_cnaps_sys_bank_no -- 外币现代支付系统行号
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 更新用户编号
    ,nvl(n.h_update_dt, o.h_update_dt) as h_update_dt -- 历史更新日期
    ,nvl(n.h_update_tm, o.h_update_tm) as h_update_tm -- 历史更新时间
    ,nvl(n.rgst_land, o.rgst_land) as rgst_land -- 注册地
    ,nvl(n.imp_chn, o.imp_chn) as imp_chn -- 导入渠道
    ,nvl(n.imp_dt, o.imp_dt) as imp_dt -- 导入日期
    ,nvl(n.core_cust_no, o.core_cust_no) as core_cust_no -- 核心客户号
    ,nvl(n.cust_cls, o.cust_cls) as cust_cls -- 客户分类
    ,nvl(n.org_hibchy_cd, o.org_hibchy_cd) as org_hibchy_cd -- 机构层级代码
    ,nvl(n.matn_org_id, o.matn_org_id) as matn_org_id -- 维护机构编号
    ,nvl(n.matn_org_name, o.matn_org_name) as matn_org_name -- 维护机构名称
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.mar_maker_flg, o.mar_maker_flg) as mar_maker_flg -- 做市商标志
    ,nvl(n.effect_flg, o.effect_flg) as effect_flg -- 生效标志
    ,nvl(n.en_name, o.en_name) as en_name -- 英文名称
    ,nvl(n.en_fname, o.en_fname) as en_fname -- 英文全称
    ,nvl(n.spv_asset_flg, o.spv_asset_flg) as spv_asset_flg -- SPV资产标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.org_id is null
                and o.lp_id is null
            ) or (
                o.intnal_org_id <> n.intnal_org_id
                or o.org_name <> n.org_name
                or o.org_fname <> n.org_fname
                or o.org_alias <> n.org_alias
                or o.org_pinyin <> n.org_pinyin
                or o.org_status_cd <> n.org_status_cd
                or o.org_cls_cd <> n.org_cls_cd
                or o.prod_type_cd <> n.prod_type_cd
                or o.found_dt <> n.found_dt
                or o.bus_lics <> n.bus_lics
                or o.org_cd_cert <> n.org_cd_cert
                or o.fin_lics <> n.fin_lics
                or o.dc_cnaps_sys_bank_no <> n.dc_cnaps_sys_bank_no
                or o.fcurr_cnaps_sys_bank_no <> n.fcurr_cnaps_sys_bank_no
                or o.update_user_id <> n.update_user_id
                or o.h_update_dt <> n.h_update_dt
                or o.h_update_tm <> n.h_update_tm
                or o.rgst_land <> n.rgst_land
                or o.imp_chn <> n.imp_chn
                or o.imp_dt <> n.imp_dt
                or o.core_cust_no <> n.core_cust_no
                or o.cust_cls <> n.cust_cls
                or o.org_hibchy_cd <> n.org_hibchy_cd
                or o.matn_org_id <> n.matn_org_id
                or o.matn_org_name <> n.matn_org_name
                or o.cust_type_cd <> n.cust_type_cd
                or o.mar_maker_flg <> n.mar_maker_flg
                or o.effect_flg <> n.effect_flg
                or o.en_name <> n.en_name
                or o.en_fname <> n.en_fname
                or o.spv_asset_flg <> n.spv_asset_flg
            )
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.org_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.org_ibank_org_ibmsf1_tm n
    full join ${iml_schema}.org_ibank_org_ibmsf1_bk o
        on
            o.org_id = n.org_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.org_ibank_org truncate partition for ('ibmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.org_ibank_org exchange subpartition p_ibmsf1_${batch_date} with table ${iml_schema}.org_ibank_org_ibmsf1_ex;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.org_ibank_org to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.org_ibank_org_ibmsf1_tm purge;
drop table ${iml_schema}.org_ibank_org_ibmsf1_ex purge;
drop table ${iml_schema}.org_ibank_org_ibmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'org_ibank_org', partname => 'p_ibmsf1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);