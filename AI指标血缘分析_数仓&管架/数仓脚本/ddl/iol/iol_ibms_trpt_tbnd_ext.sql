/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_trpt_tbnd_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_trpt_tbnd_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_trpt_tbnd_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_trpt_tbnd_ext(
    i_code varchar2(45) -- 债券代码
    ,a_type varchar2(30) -- 资产类型
    ,m_type varchar2(30) -- 市场类型
    ,p_class_ext varchar2(90) -- 产品分类
    ,hx_businessmiddle varchar2(150) -- 业务中类
    ,hx_businesssmall varchar2(150) -- 业务小类
    ,hx_investcategory varchar2(750) -- 投向行业门类
    ,hx_investbroheading varchar2(750) -- 投向行业大类
    ,hx_islocfinanc varchar2(150) -- 是否地方政府融资平台
    ,hx_isdistbus varchar2(150) -- 是否异地业务
    ,hx_isgover_fund varchar2(150) -- 是否政府投资基金
    ,hx_isvc_fund varchar2(150) -- 是否创业投资基金
    ,hx_incredit_type varchar2(150) -- 增信方式
    ,hx_cremainname varchar2(450) -- 增信主体名称
    ,hxabs_invest1_type varchar2(150) -- 投资分类1
    ,hxabs_invest2_type varchar2(150) -- 投资分类2
    ,hxabs_investamount number(31,2) -- 原投资产总金额（万元）
    ,hxabs_investinfeamount number(31,2) -- 原投资产品劣后级金额（万元）
    ,hxabs_creditassecu varchar2(150) -- 信贷资产支持证券
    ,hxabs_csrcalloassecu varchar2(150) -- 证监会同意发行的企业资产支持证券
    ,hx_creditpartyid number(22) -- 授信主体
    ,hx_basictrader varchar2(1500) -- 基础资产客户
    ,hx_undatype varchar2(300) -- 底层资产类型
    ,hxabs_penetration_type varchar2(8) -- 穿透类型
    ,hxabs_isdebt_for_equity varchar2(2) -- 是否投向市场化债转股
    ,hxabs_isconsumer_financing varchar2(2) -- 是否为消费服务类融资
    ,hxabs_againabs varchar2(150) -- 是否再资产证券化(1:是,0否)
    ,hx_amount_level number(20,2) -- 该档次总金额
    ,hx_blc number(31,8) -- 产品当期总余额(亿)
    ,hx_blc_level number(31,8) -- 持有档次当期余额(亿)
    ,hx_grade_date_bond varchar2(15) -- 评级日期(债项)
    ,hx_grade_date_inst varchar2(15) -- 评级日期(主体)
    ,hx_inst_grade varchar2(75) -- 主体评级
    ,hx_inst_grade_org varchar2(300) -- 主体评级机构
    ,hx_is_stc varchar2(15) -- 是否stc
    ,hx_priority_level varchar2(15) -- 优先档次，优先|非优先
    ,hx_estate_bond_type varchar2(75) -- 房地产债券类型
    ,hx_is_green_finance varchar2(3) -- 
    ,hx_first_option_type varchar2(6) -- 
    ,hx_second_option_type varchar2(15) -- 
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
grant select on ${iol_schema}.ibms_trpt_tbnd_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_trpt_tbnd_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_trpt_tbnd_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_trpt_tbnd_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_trpt_tbnd_ext is '债券补录信息表';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.i_code is '债券代码';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.a_type is '资产类型';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.m_type is '市场类型';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.p_class_ext is '产品分类';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_businessmiddle is '业务中类';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_businesssmall is '业务小类';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_investcategory is '投向行业门类';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_investbroheading is '投向行业大类';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_islocfinanc is '是否地方政府融资平台';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_isdistbus is '是否异地业务';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_isgover_fund is '是否政府投资基金';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_isvc_fund is '是否创业投资基金';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_incredit_type is '增信方式';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_cremainname is '增信主体名称';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_invest1_type is '投资分类1';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_invest2_type is '投资分类2';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_investamount is '原投资产总金额（万元）';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_investinfeamount is '原投资产品劣后级金额（万元）';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_creditassecu is '信贷资产支持证券';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_csrcalloassecu is '证监会同意发行的企业资产支持证券';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_creditpartyid is '授信主体';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_basictrader is '基础资产客户';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_undatype is '底层资产类型';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_penetration_type is '穿透类型';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_isdebt_for_equity is '是否投向市场化债转股';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_isconsumer_financing is '是否为消费服务类融资';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hxabs_againabs is '是否再资产证券化(1:是,0否)';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_amount_level is '该档次总金额';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_blc is '产品当期总余额(亿)';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_blc_level is '持有档次当期余额(亿)';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_grade_date_bond is '评级日期(债项)';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_grade_date_inst is '评级日期(主体)';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_inst_grade is '主体评级';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_inst_grade_org is '主体评级机构';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_is_stc is '是否stc';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_priority_level is '优先档次，优先|非优先';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_estate_bond_type is '房地产债券类型';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_is_green_finance is '';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_first_option_type is '';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.hx_second_option_type is '';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_trpt_tbnd_ext.etl_timestamp is 'ETL处理时间戳';
