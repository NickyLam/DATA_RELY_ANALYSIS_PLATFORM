/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_common_orgcode
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_common_orgcode
whenever sqlerror continue none;
drop table ${iol_schema}.noas_common_orgcode purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_common_orgcode(
    organ_code_key varchar2(30) -- 机构唯一标识
    ,organ_code varchar2(30) -- 内部机构编号
    ,fun_organ varchar2(30) -- 职能机构
    ,fun_dep varchar2(30) -- 职能部门
    ,zoneno varchar2(30) -- 分行号
    ,p_bo_c_financial_code varchar2(90) -- 人民银行金融机构编号
    ,financial_code varchar2(45) -- 金融机构标识码
    ,s_w_i_f_t_code varchar2(45) -- swift号码
    ,bank_code varchar2(30) -- 支付系统银行行号
    ,legal varchar2(30) -- 法人号
    ,business_license varchar2(30) -- 营业执照号码
    ,organization_code varchar2(30) -- 组织机构代码
    ,tax_id varchar2(30) -- 税务登记证号
    ,organ_cn_full_name varchar2(383) -- 组织机构名称
    ,organ_cn_short_name varchar2(383) -- 组织机构简称
    ,organ_en_full_name varchar2(383) -- 组织机构英文全称
    ,organ_en_short_name varchar2(383) -- 组织机构英文简称
    ,organ_state_code varchar2(30) -- 机构营业状态
    ,organ_status varchar2(30) -- 机构状态
    ,organ_founding_date varchar2(30) -- 机构成立日期
    ,organ_close_date varchar2(30) -- 机构关闭日期
    ,organ_type varchar2(30) -- 组织机构类型
    ,is_st varchar2(30) -- 是否为实体机构
    ,is_hs varchar2(30) -- 是否为核算机构
    ,is_yy varchar2(30) -- 是否为营业机构
    ,is_xz varchar2(30) -- 是否为行政机构
    ,is_zw varchar2(30) -- 是否为账务机构
    ,organ_level varchar2(30) -- 组织机构级别代码
    ,leaf_note_flag varchar2(30) -- 叶节点标志
    ,xzup_organ_code varchar2(30) -- 行政上级组织机构编码
    ,zwup_organ_code varchar2(30) -- 账务上级组织机构编码
    ,hsup_organ_code varchar2(30) -- 核算上级组织机构编码
    ,seque varchar2(30) -- 机构顺序号
    ,post_code varchar2(30) -- 邮政编码
    ,country varchar2(30) -- 所在国家
    ,province varchar2(30) -- 所在省/州
    ,city varchar2(30) -- 所在城市
    ,county varchar2(30) -- 所在县/区
    ,address varchar2(600) -- 详细地址
    ,email varchar2(90) -- 电子邮箱
    ,u_r_l varchar2(90) -- 网址
    ,country_code varchar2(30) -- 国际长途区号
    ,area_code varchar2(30) -- 国内长途区号
    ,phone varchar2(45) -- 电话号码
    ,sub_phone varchar2(30) -- 分机号
    ,service_phone varchar2(30) -- 服务电话
    ,financial_lic_num varchar2(45) -- 金融许可证号码
    ,organ_system varchar2(30) -- 机构关联系统
    ,last_updated_stamp timestamp -- bosent自带最后修改时间
    ,last_updated_tx_stamp timestamp -- bosent自带最后修改时间
    ,created_stamp timestamp -- bosent自带创建时间
    ,created_tx_stamp timestamp -- bosent自带创建时间
    ,orderno varchar2(30) -- 显示顺序号
    ,cbrcfininstt_id varchar2(90) -- 银监会金融机构编号
    ,union_financial_code varchar2(30) -- 银联金融机构编号
    ,isxnhs varchar2(30) -- 是否为虚拟核算机构   入职需要
    ,head_emply_id varchar2(30) -- 机构类型为核算时，校验为必输
    ,is_business_division varchar2(30) -- 是否为事业部
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
grant select on ${iol_schema}.noas_common_orgcode to ${iml_schema};
grant select on ${iol_schema}.noas_common_orgcode to ${icl_schema};
grant select on ${iol_schema}.noas_common_orgcode to ${idl_schema};
grant select on ${iol_schema}.noas_common_orgcode to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_common_orgcode is '部门表';
comment on column ${iol_schema}.noas_common_orgcode.organ_code_key is '机构唯一标识';
comment on column ${iol_schema}.noas_common_orgcode.organ_code is '内部机构编号';
comment on column ${iol_schema}.noas_common_orgcode.fun_organ is '职能机构';
comment on column ${iol_schema}.noas_common_orgcode.fun_dep is '职能部门';
comment on column ${iol_schema}.noas_common_orgcode.zoneno is '分行号';
comment on column ${iol_schema}.noas_common_orgcode.p_bo_c_financial_code is '人民银行金融机构编号';
comment on column ${iol_schema}.noas_common_orgcode.financial_code is '金融机构标识码';
comment on column ${iol_schema}.noas_common_orgcode.s_w_i_f_t_code is 'swift号码';
comment on column ${iol_schema}.noas_common_orgcode.bank_code is '支付系统银行行号';
comment on column ${iol_schema}.noas_common_orgcode.legal is '法人号';
comment on column ${iol_schema}.noas_common_orgcode.business_license is '营业执照号码';
comment on column ${iol_schema}.noas_common_orgcode.organization_code is '组织机构代码';
comment on column ${iol_schema}.noas_common_orgcode.tax_id is '税务登记证号';
comment on column ${iol_schema}.noas_common_orgcode.organ_cn_full_name is '组织机构名称';
comment on column ${iol_schema}.noas_common_orgcode.organ_cn_short_name is '组织机构简称';
comment on column ${iol_schema}.noas_common_orgcode.organ_en_full_name is '组织机构英文全称';
comment on column ${iol_schema}.noas_common_orgcode.organ_en_short_name is '组织机构英文简称';
comment on column ${iol_schema}.noas_common_orgcode.organ_state_code is '机构营业状态';
comment on column ${iol_schema}.noas_common_orgcode.organ_status is '机构状态';
comment on column ${iol_schema}.noas_common_orgcode.organ_founding_date is '机构成立日期';
comment on column ${iol_schema}.noas_common_orgcode.organ_close_date is '机构关闭日期';
comment on column ${iol_schema}.noas_common_orgcode.organ_type is '组织机构类型';
comment on column ${iol_schema}.noas_common_orgcode.is_st is '是否为实体机构';
comment on column ${iol_schema}.noas_common_orgcode.is_hs is '是否为核算机构';
comment on column ${iol_schema}.noas_common_orgcode.is_yy is '是否为营业机构';
comment on column ${iol_schema}.noas_common_orgcode.is_xz is '是否为行政机构';
comment on column ${iol_schema}.noas_common_orgcode.is_zw is '是否为账务机构';
comment on column ${iol_schema}.noas_common_orgcode.organ_level is '组织机构级别代码';
comment on column ${iol_schema}.noas_common_orgcode.leaf_note_flag is '叶节点标志';
comment on column ${iol_schema}.noas_common_orgcode.xzup_organ_code is '行政上级组织机构编码';
comment on column ${iol_schema}.noas_common_orgcode.zwup_organ_code is '账务上级组织机构编码';
comment on column ${iol_schema}.noas_common_orgcode.hsup_organ_code is '核算上级组织机构编码';
comment on column ${iol_schema}.noas_common_orgcode.seque is '机构顺序号';
comment on column ${iol_schema}.noas_common_orgcode.post_code is '邮政编码';
comment on column ${iol_schema}.noas_common_orgcode.country is '所在国家';
comment on column ${iol_schema}.noas_common_orgcode.province is '所在省/州';
comment on column ${iol_schema}.noas_common_orgcode.city is '所在城市';
comment on column ${iol_schema}.noas_common_orgcode.county is '所在县/区';
comment on column ${iol_schema}.noas_common_orgcode.address is '详细地址';
comment on column ${iol_schema}.noas_common_orgcode.email is '电子邮箱';
comment on column ${iol_schema}.noas_common_orgcode.u_r_l is '网址';
comment on column ${iol_schema}.noas_common_orgcode.country_code is '国际长途区号';
comment on column ${iol_schema}.noas_common_orgcode.area_code is '国内长途区号';
comment on column ${iol_schema}.noas_common_orgcode.phone is '电话号码';
comment on column ${iol_schema}.noas_common_orgcode.sub_phone is '分机号';
comment on column ${iol_schema}.noas_common_orgcode.service_phone is '服务电话';
comment on column ${iol_schema}.noas_common_orgcode.financial_lic_num is '金融许可证号码';
comment on column ${iol_schema}.noas_common_orgcode.organ_system is '机构关联系统';
comment on column ${iol_schema}.noas_common_orgcode.last_updated_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_common_orgcode.last_updated_tx_stamp is 'bosent自带最后修改时间';
comment on column ${iol_schema}.noas_common_orgcode.created_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_common_orgcode.created_tx_stamp is 'bosent自带创建时间';
comment on column ${iol_schema}.noas_common_orgcode.orderno is '显示顺序号';
comment on column ${iol_schema}.noas_common_orgcode.cbrcfininstt_id is '银监会金融机构编号';
comment on column ${iol_schema}.noas_common_orgcode.union_financial_code is '银联金融机构编号';
comment on column ${iol_schema}.noas_common_orgcode.isxnhs is '是否为虚拟核算机构   入职需要';
comment on column ${iol_schema}.noas_common_orgcode.head_emply_id is '机构类型为核算时，校验为必输';
comment on column ${iol_schema}.noas_common_orgcode.is_business_division is '是否为事业部';
comment on column ${iol_schema}.noas_common_orgcode.start_dt is '开始时间';
comment on column ${iol_schema}.noas_common_orgcode.end_dt is '结束时间';
comment on column ${iol_schema}.noas_common_orgcode.id_mark is '增删标志';
comment on column ${iol_schema}.noas_common_orgcode.etl_timestamp is 'ETL处理时间戳';
