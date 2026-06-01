/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_industry
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_industry
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_industry purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_industry(
    industry_id number(10,0) -- 行业ID
    ,industry_name varchar2(450) -- 行业名称
    ,parent_industry number(10,0) -- 所属行业
    ,thi_industry varchar2(16) -- 第三方行业类别商户信息报备时使用
    ,deal_type number(4,0) -- 经营类型1:实体;2:虚拟
    ,remark varchar2(256) -- 备注
    ,create_user number(10,0) -- 创建用户
    ,create_emp varchar2(32) -- 创建人
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,ali_industry varchar2(32) -- 阿里第三方行业类别
    ,qq_industry varchar2(256) -- qq行业类别
    ,alipay_authorization_desc varchar2(256) -- 描述需要哪些执照和许可证，创建支付宝门店的时候需要用到
    ,ali_v2_industry varchar2(128) -- 支付宝V2报备行业类别
    ,best_pay_industry varchar2(32) -- 翼支付行业类别
    ,hebao_industry varchar2(30) -- 和包行业类别
    ,yifubao_industry varchar2(30) -- 易付宝行业类别
    ,union_pay_industry varchar2(32) -- 银联二维码行业类别
    ,shengfutong_industry varchar2(32) -- 盛付通行业类别
    ,jd_industry varchar2(32) -- 京东行业类别
    ,union_qq_industry varchar2(20) -- 银联QQ钱包行业类别
    ,mcc varchar2(10) -- MCC码
    ,fld_s1 varchar2(256) -- 字符备用1
    ,fld_s2 varchar2(256) -- 字符备用2
    ,fld_s3 varchar2(256) -- 字符备用3
    ,fld_s4 varchar2(256) -- 字符备用4
    ,fld_s5 varchar2(256) -- 字符备用5
    ,yz_industry varchar2(32) -- 银总行业类别
    ,wx_settlement_id_normal varchar2(16) -- 微信结算id(普通)
    ,wx_settlement_id_newsmall varchar2(16) -- 微信结算id(小微)
    ,wx_settlement_id_normal2 varchar2(128) -- 
    ,wx_settlement_id_newsmall2 varchar2(128) -- 
    ,bank_industry varchar2(128) -- 银行的行业Id
    ,union_unstandard_flag number(2,0) -- 银联非标费率标识，0-标准费率;1-可非标费率
    ,root_industry number(10,0) -- ROOT行业类别
    ,industry_level number(2,0) -- 行业分级
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
grant select on ${iol_schema}.amss_cms_industry to ${iml_schema};
grant select on ${iol_schema}.amss_cms_industry to ${icl_schema};
grant select on ${iol_schema}.amss_cms_industry to ${idl_schema};
grant select on ${iol_schema}.amss_cms_industry to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_industry is '行业类别表';
comment on column ${iol_schema}.amss_cms_industry.industry_id is '行业ID';
comment on column ${iol_schema}.amss_cms_industry.industry_name is '行业名称';
comment on column ${iol_schema}.amss_cms_industry.parent_industry is '所属行业';
comment on column ${iol_schema}.amss_cms_industry.thi_industry is '第三方行业类别商户信息报备时使用';
comment on column ${iol_schema}.amss_cms_industry.deal_type is '经营类型1:实体;2:虚拟';
comment on column ${iol_schema}.amss_cms_industry.remark is '备注';
comment on column ${iol_schema}.amss_cms_industry.create_user is '创建用户';
comment on column ${iol_schema}.amss_cms_industry.create_emp is '创建人';
comment on column ${iol_schema}.amss_cms_industry.create_time is '创建时间';
comment on column ${iol_schema}.amss_cms_industry.update_time is '更新时间';
comment on column ${iol_schema}.amss_cms_industry.ali_industry is '阿里第三方行业类别';
comment on column ${iol_schema}.amss_cms_industry.qq_industry is 'qq行业类别';
comment on column ${iol_schema}.amss_cms_industry.alipay_authorization_desc is '描述需要哪些执照和许可证，创建支付宝门店的时候需要用到';
comment on column ${iol_schema}.amss_cms_industry.ali_v2_industry is '支付宝V2报备行业类别';
comment on column ${iol_schema}.amss_cms_industry.best_pay_industry is '翼支付行业类别';
comment on column ${iol_schema}.amss_cms_industry.hebao_industry is '和包行业类别';
comment on column ${iol_schema}.amss_cms_industry.yifubao_industry is '易付宝行业类别';
comment on column ${iol_schema}.amss_cms_industry.union_pay_industry is '银联二维码行业类别';
comment on column ${iol_schema}.amss_cms_industry.shengfutong_industry is '盛付通行业类别';
comment on column ${iol_schema}.amss_cms_industry.jd_industry is '京东行业类别';
comment on column ${iol_schema}.amss_cms_industry.union_qq_industry is '银联QQ钱包行业类别';
comment on column ${iol_schema}.amss_cms_industry.mcc is 'MCC码';
comment on column ${iol_schema}.amss_cms_industry.fld_s1 is '字符备用1';
comment on column ${iol_schema}.amss_cms_industry.fld_s2 is '字符备用2';
comment on column ${iol_schema}.amss_cms_industry.fld_s3 is '字符备用3';
comment on column ${iol_schema}.amss_cms_industry.fld_s4 is '字符备用4';
comment on column ${iol_schema}.amss_cms_industry.fld_s5 is '字符备用5';
comment on column ${iol_schema}.amss_cms_industry.yz_industry is '银总行业类别';
comment on column ${iol_schema}.amss_cms_industry.wx_settlement_id_normal is '微信结算id(普通)';
comment on column ${iol_schema}.amss_cms_industry.wx_settlement_id_newsmall is '微信结算id(小微)';
comment on column ${iol_schema}.amss_cms_industry.wx_settlement_id_normal2 is '';
comment on column ${iol_schema}.amss_cms_industry.wx_settlement_id_newsmall2 is '';
comment on column ${iol_schema}.amss_cms_industry.bank_industry is '银行的行业Id';
comment on column ${iol_schema}.amss_cms_industry.union_unstandard_flag is '银联非标费率标识，0-标准费率;1-可非标费率';
comment on column ${iol_schema}.amss_cms_industry.root_industry is 'ROOT行业类别';
comment on column ${iol_schema}.amss_cms_industry.industry_level is '行业分级';
comment on column ${iol_schema}.amss_cms_industry.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_industry.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_industry.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_industry.etl_timestamp is 'ETL处理时间戳';
