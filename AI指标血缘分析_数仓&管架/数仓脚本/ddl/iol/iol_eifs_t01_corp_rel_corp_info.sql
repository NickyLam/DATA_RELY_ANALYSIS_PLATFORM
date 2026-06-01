/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_rel_corp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_rel_corp_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_rel_corp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_rel_corp_info(
    rel_enterp_id varchar2(45) -- 关系企业id
    ,party_id varchar2(45) -- 参与人id
    ,rela_cust_rela_cd varchar2(30) -- 关联方关系
    ,rela_num varchar2(90) -- 关联方编号
    ,party_relationship_type_id varchar2(90) -- 关系大类型
    ,rela_name varchar2(300) -- 关联方名称
    ,rela_cert_type_cd varchar2(30) -- 关联方证件类型
    ,rela_cert_num varchar2(90) -- 关联方证件号码
    ,exp_date_of_rela_cert varchar2(12) -- 关联方证件失效日期
    ,rela_addr varchar2(600) -- 关联方联系地址
    ,rela_tel_num varchar2(45) -- 关联方联系电话
    ,rela_stat_cd varchar2(30) -- 关联关系状态
    ,tax_pay_ctzn_idnt varchar2(11) -- 税收居民身份
    ,rela_group_num varchar2(90) -- 关联方集团号
    ,rela_nation_cd varchar2(30) -- 关联方国籍
    ,contri_ratio number(20,6) -- 出资比例
    ,hold_stock_amount number(20,6) -- 持股数量
    ,hold_stock_ratio number(20,6) -- 持股比例
    ,oper_timelimit varchar2(30) -- 经营期限
    ,corp_found_dt varchar2(12) -- 企业成立日期
    ,legal_rep_name varchar2(300) -- 法定代表人名称
    ,leg_repres_cert_type varchar2(15) -- 法定代表人证件种类
    ,leg_repres_cert_no varchar2(90) -- 法定代表人证件号码
    ,legal_cert_valid_date varchar2(12) -- 法定代表人证件有效日期
    ,legal_person_tel_no varchar2(30) -- 法定代表人联系电话
    ,create_te varchar2(15) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,assoc_open_lice varchar2(90) -- 关联方开户许可证
    ,superior_org_code varchar2(90) -- 上级机构组织机构代码
    ,superior_org_credit_code varchar2(90) -- 上级机构信用代码
    ,competent_org_reg_currency varchar2(44) -- 主管单位注册币种
    ,competent_org_reg_amt number(20,2) -- 主管单位注册金额
    ,rela_zone_code varchar2(45) -- 关联人电话国内区号
    ,phone_no varchar2(45) -- 手机号码
    ,mobile_phone varchar2(45) -- 联系手机
    ,rela_cert_effect_dt varchar2(12) -- 关联人证件生效日期
    ,ctrler_typ_cd varchar2(150) -- 控制人类型代码
    ,shrh_typ_cd varchar2(150) -- 股东类型
    ,shrh_flag_new varchar2(30) -- 是否本行股东标志
    ,role_type_id_to varchar2(150) -- 关系小类
    ,lnkm_self_cert_decl_flg varchar2(150) -- 关联人自证声明标志
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.eifs_t01_corp_rel_corp_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_rel_corp_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_rel_corp_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_rel_corp_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_rel_corp_info is '对公关系企业信息';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rel_enterp_id is '关系企业id';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.party_id is '参与人id';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_cust_rela_cd is '关联方关系';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_num is '关联方编号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.party_relationship_type_id is '关系大类型';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_name is '关联方名称';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_cert_type_cd is '关联方证件类型';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_cert_num is '关联方证件号码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.exp_date_of_rela_cert is '关联方证件失效日期';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_addr is '关联方联系地址';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_tel_num is '关联方联系电话';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_stat_cd is '关联关系状态';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.tax_pay_ctzn_idnt is '税收居民身份';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_group_num is '关联方集团号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_nation_cd is '关联方国籍';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.contri_ratio is '出资比例';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.hold_stock_amount is '持股数量';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.hold_stock_ratio is '持股比例';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.oper_timelimit is '经营期限';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.corp_found_dt is '企业成立日期';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.legal_rep_name is '法定代表人名称';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.leg_repres_cert_type is '法定代表人证件种类';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.leg_repres_cert_no is '法定代表人证件号码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.legal_cert_valid_date is '法定代表人证件有效日期';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.legal_person_tel_no is '法定代表人联系电话';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.assoc_open_lice is '关联方开户许可证';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.superior_org_code is '上级机构组织机构代码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.superior_org_credit_code is '上级机构信用代码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.competent_org_reg_currency is '主管单位注册币种';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.competent_org_reg_amt is '主管单位注册金额';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_zone_code is '关联人电话国内区号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.phone_no is '手机号码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.mobile_phone is '联系手机';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.rela_cert_effect_dt is '关联人证件生效日期';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.ctrler_typ_cd is '控制人类型代码';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.shrh_typ_cd is '股东类型';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.shrh_flag_new is '是否本行股东标志';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.role_type_id_to is '关系小类';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.lnkm_self_cert_decl_flg is '关联人自证声明标志';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_rel_corp_info.etl_timestamp is 'ETL处理时间戳';
