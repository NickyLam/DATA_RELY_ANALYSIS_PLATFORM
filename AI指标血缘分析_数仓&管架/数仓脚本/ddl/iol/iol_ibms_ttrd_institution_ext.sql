/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_institution_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_institution_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_institution_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_institution_ext(
    i_id varchar2(33) -- 主键
    ,h_datefield varchar2(29) -- 日期类型
    ,h_textfield varchar2(90) -- 文本类型
    ,h_numberfield number(31,2) -- 数值类型
    ,h_combobox varchar2(150) -- 下拉框类型
    ,h_textarea varchar2(4000) -- 文本域类型
    ,hx_industy varchar2(45) -- 最终投向行业-大类
    ,hx_industy_detail varchar2(45) -- 最终投向行业-细类
    ,rh_custeconomypart varchar2(750) -- 客户国民经济部门
    ,rh_businesstype varchar2(750) -- 所属行业
    ,rh_isrelevancy varchar2(150) -- 是否关联方
    ,rh_code varchar2(150) -- 代码
    ,rh_institutioncode varchar2(150) -- 金融机构编码
    ,rh_depositaccount varchar2(150) -- 基本存款账户
    ,rh_economicsector varchar2(450) -- 经济成分
    ,rh_bankname varchar2(150) -- 基本账户开户行名称
    ,rh_regist varchar2(675) -- 注册地址
    ,rh_innerrate varchar2(150) -- 内部评级
    ,rh_firmsize varchar2(150) -- 企业规模
    ,rh_begindate varchar2(150) -- 成立日期
    ,rh_registcode varchar2(150) -- 注册地行政区划码
    ,rh_codetype varchar2(150) -- 代码类别
    ,rh_custtype varchar2(150) -- 客户类别
    ,hx_juridical_p_cert_type varchar2(45) -- 法人证件类型
    ,hx_juridical_p_cert_code varchar2(45) -- 法人证件号码
    ,hx_pd_of_vali4juridical_p_cert varchar2(15) -- 法人证件有效期
    ,funds_prsv varchar2(150) -- 资管产品统计编码
    ,prim_org_ptyid varchar2(30) -- 主机构客户号
    ,spv_cd varchar2(150) -- spv代码
    ,spv_name varchar2(375) -- spv名称
    ,spv_type varchar2(150) -- spv类型
    ,rh_businesstype_m varchar2(750) -- 行业类型,数据标准落标,触发器添加
    ,rh_economicsector_m varchar2(450) -- 经济成分,数据标准落标,触发器添加
    ,hx_adminiarea varchar2(450) -- 行政区划代码
    ,hx_deteilarea varchar2(675) -- 详细地址(不含行政区划)
    ,hx_deteiladdress varchar2(750) -- 详细地址(含行政区划)
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
grant select on ${iol_schema}.ibms_ttrd_institution_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_institution_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_institution_ext is '机构扩展信息表';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.i_id is '主键';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.h_datefield is '日期类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.h_textfield is '文本类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.h_numberfield is '数值类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.h_combobox is '下拉框类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.h_textarea is '文本域类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_industy is '最终投向行业-大类';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_industy_detail is '最终投向行业-细类';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_custeconomypart is '客户国民经济部门';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_businesstype is '所属行业';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_isrelevancy is '是否关联方';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_code is '代码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_institutioncode is '金融机构编码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_depositaccount is '基本存款账户';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_economicsector is '经济成分';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_bankname is '基本账户开户行名称';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_regist is '注册地址';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_innerrate is '内部评级';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_firmsize is '企业规模';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_begindate is '成立日期';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_registcode is '注册地行政区划码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_codetype is '代码类别';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_custtype is '客户类别';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_juridical_p_cert_type is '法人证件类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_juridical_p_cert_code is '法人证件号码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_pd_of_vali4juridical_p_cert is '法人证件有效期';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.funds_prsv is '资管产品统计编码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.prim_org_ptyid is '主机构客户号';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.spv_cd is 'spv代码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.spv_name is 'spv名称';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.spv_type is 'spv类型';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_businesstype_m is '行业类型,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.rh_economicsector_m is '经济成分,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_adminiarea is '行政区划代码';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_deteilarea is '详细地址(不含行政区划)';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.hx_deteiladdress is '详细地址(含行政区划)';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_institution_ext.etl_timestamp is 'ETL处理时间戳';
