/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl icrm_org_ibank_org
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.icrm_org_ibank_org
whenever sqlerror continue none;
drop table ${idl_schema}.icrm_org_ibank_org purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.icrm_org_ibank_org(
    etl_dt date -- 数据日期
    ,org_id varchar2(60) -- 机构编号
    ,lp_id varchar2(60) -- 法人编号
    ,intnal_org_id varchar2(60) -- 内部机构编号
    ,org_name varchar2(100) -- 机构名称
    ,org_fname varchar2(100) -- 机构全称
    ,org_alias varchar2(100) -- 机构别名
    ,org_pinyin varchar2(100) -- 机构拼音
    ,org_status_cd varchar2(10) -- 机构状态代码
    ,org_cls_cd varchar2(10) -- 机构分类代码
    ,prod_type_cd varchar2(10) -- 产品类型代码
    ,found_dt date -- 成立日期
    ,bus_lics varchar2(60) -- 营业执照
    ,org_cd_cert varchar2(60) -- 机构代码证
    ,fin_lics varchar2(60) -- 金融许可证
    ,dc_cnaps_sys_bank_no varchar2(60) -- 本币现代支付系统行号
    ,fcurr_cnaps_sys_bank_no varchar2(60) -- 外币现代支付系统行号
    ,update_user_id varchar2(60) -- 更新用户编号
    ,h_update_dt date -- 历史更新日期
    ,h_update_tm varchar2(20) -- 历史更新时间
    ,rgst_land varchar2(100) -- 注册地
    ,imp_chn varchar2(10) -- 导入渠道
    ,imp_dt date -- 导入日期
    ,core_cust_no varchar2(60) -- 核心客户号
    ,cust_cls varchar2(200) -- 客户分类
    ,org_hibchy_cd varchar2(10) -- 机构层级代码
    ,matn_org_id varchar2(60) -- 维护机构编号
    ,matn_org_name varchar2(100) -- 维护机构名称
    ,cust_type_cd varchar2(10) -- 客户类型代码
    ,mar_maker_flg varchar2(10) -- 做市商标志
    ,effect_flg varchar2(10) -- 生效标志
    ,en_name varchar2(100) -- 英文名称
    ,en_fname varchar2(100) -- 英文全称
    ,spv_asset_flg varchar2(10) -- SPV资产标志
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.icrm_org_ibank_org to ${iel_schema};

-- comment
comment on table ${idl_schema}.icrm_org_ibank_org is '同业机构';
comment on column ${idl_schema}.icrm_org_ibank_org.etl_dt is '数据日期';
comment on column ${idl_schema}.icrm_org_ibank_org.org_id is '机构编号';
comment on column ${idl_schema}.icrm_org_ibank_org.lp_id is '法人编号';
comment on column ${idl_schema}.icrm_org_ibank_org.intnal_org_id is '内部机构编号';
comment on column ${idl_schema}.icrm_org_ibank_org.org_name is '机构名称';
comment on column ${idl_schema}.icrm_org_ibank_org.org_fname is '机构全称';
comment on column ${idl_schema}.icrm_org_ibank_org.org_alias is '机构别名';
comment on column ${idl_schema}.icrm_org_ibank_org.org_pinyin is '机构拼音';
comment on column ${idl_schema}.icrm_org_ibank_org.org_status_cd is '机构状态代码';
comment on column ${idl_schema}.icrm_org_ibank_org.org_cls_cd is '机构分类代码';
comment on column ${idl_schema}.icrm_org_ibank_org.prod_type_cd is '产品类型代码';
comment on column ${idl_schema}.icrm_org_ibank_org.found_dt is '成立日期';
comment on column ${idl_schema}.icrm_org_ibank_org.bus_lics is '营业执照';
comment on column ${idl_schema}.icrm_org_ibank_org.org_cd_cert is '机构代码证';
comment on column ${idl_schema}.icrm_org_ibank_org.fin_lics is '金融许可证';
comment on column ${idl_schema}.icrm_org_ibank_org.dc_cnaps_sys_bank_no is '本币现代支付系统行号';
comment on column ${idl_schema}.icrm_org_ibank_org.fcurr_cnaps_sys_bank_no is '外币现代支付系统行号';
comment on column ${idl_schema}.icrm_org_ibank_org.update_user_id is '更新用户编号';
comment on column ${idl_schema}.icrm_org_ibank_org.h_update_dt is '历史更新日期';
comment on column ${idl_schema}.icrm_org_ibank_org.h_update_tm is '历史更新时间';
comment on column ${idl_schema}.icrm_org_ibank_org.rgst_land is '注册地';
comment on column ${idl_schema}.icrm_org_ibank_org.imp_chn is '导入渠道';
comment on column ${idl_schema}.icrm_org_ibank_org.imp_dt is '导入日期';
comment on column ${idl_schema}.icrm_org_ibank_org.core_cust_no is '核心客户号';
comment on column ${idl_schema}.icrm_org_ibank_org.cust_cls is '客户分类';
comment on column ${idl_schema}.icrm_org_ibank_org.org_hibchy_cd is '机构层级代码';
comment on column ${idl_schema}.icrm_org_ibank_org.matn_org_id is '维护机构编号';
comment on column ${idl_schema}.icrm_org_ibank_org.matn_org_name is '维护机构名称';
comment on column ${idl_schema}.icrm_org_ibank_org.cust_type_cd is '客户类型代码';
comment on column ${idl_schema}.icrm_org_ibank_org.mar_maker_flg is '做市商标志';
comment on column ${idl_schema}.icrm_org_ibank_org.effect_flg is '生效标志';
comment on column ${idl_schema}.icrm_org_ibank_org.en_name is '英文名称';
comment on column ${idl_schema}.icrm_org_ibank_org.en_fname is '英文全称';
comment on column ${idl_schema}.icrm_org_ibank_org.spv_asset_flg is 'SPV资产标志';
comment on column ${idl_schema}.icrm_org_ibank_org.job_cd is '任务代码';
comment on column ${idl_schema}.icrm_org_ibank_org.etl_timestamp is '数据处理时间';
