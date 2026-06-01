/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mc_wind_org_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mc_wind_org_para
whenever sqlerror continue none;
drop table ${idl_schema}.mc_wind_org_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mc_wind_org_para(
     first_code  VARCHAR2(60)  -- 一级分类代码
    ,first_name  VARCHAR2(200) -- 一级分类名称
    ,second_code VARCHAR2(60)  -- 二级分类代码
    ,second_name VARCHAR2(200) -- 二级分类名称
    ,third_code  VARCHAR2(60)  -- 三级分类代码
    ,third_name  VARCHAR2(200) -- 三级分类名称
    ,source_sys  VARCHAR2(10)  -- 数据来源
    ,remark      VARCHAR2(200) -- 备注
    ,update_dt   timestamp     -- 更新时间

)
storage (initial 128k next 128k)
compress ${option_switch} for query high
nologging
;

-- grant
-- comment
comment on table ${idl_schema}.mc_wind_org_para is '万德机构类别参数表';
comment on column ${idl_schema}.mc_wind_org_para.first_code  is '一级分类代码';
comment on column ${idl_schema}.mc_wind_org_para.first_name  is '一级分类名称';
comment on column ${idl_schema}.mc_wind_org_para.second_code is '二级分类代码';
comment on column ${idl_schema}.mc_wind_org_para.second_name is '二级分类名称';
comment on column ${idl_schema}.mc_wind_org_para.third_code  is '三级分类代码';
comment on column ${idl_schema}.mc_wind_org_para.third_name  is '三级分类名称';
comment on column ${idl_schema}.mc_wind_org_para.source_sys  is '数据来源';
comment on column ${idl_schema}.mc_wind_org_para.remark      is '备注';
comment on column ${idl_schema}.mc_wind_org_para.update_dt   is '更新时间';

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('avg', '对标行', 'avg', '对标行', 'avg', '对标行', 'mcs', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('all', '所有行合计', 'all', '所有行合计', 'all', '所有行合计', 'mcs', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010000', '存款类', '0816010000', '银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020100', '信托公司', '0816020100', '信托公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010600', '财务公司', '0816010600', '财务公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020600', '消费金融公司', '0816020600', '消费金融公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010100', '政策性银行', '0816010100', '政策性银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010300', '邮政储蓄银行', '0816010300', '邮政储蓄银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020500', '货币经纪公司', '0816020500', '货币经纪公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010500', '农村资金互助社', '0816010500', '农村资金互助社', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020300', '金融租赁公司', '0816020300', '金融租赁公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010400', '信用社', '0816010400', '信用社', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010400', '信用社', '0816010401', '农信社', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020700', '贷款公司', '0816020700', '贷款公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010207', '民营银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010220', '其他商业银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010211', '住房储蓄银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010206', '村镇银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010204', '农商行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010200', '商业银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010205', '农合行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010201', '国有商业银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010210', '外资银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010202', '股份制商业银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816010000', '银行', '0816010200', '商业银行', '0816010203', '城市商业银行', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020400', '汽车金融公司', '0816020400', '汽车金融公司', 'wind', null, null);

insert into mc_wind_org_para (FIRST_CODE, FIRST_NAME, SECOND_CODE, SECOND_NAME, THIRD_CODE, THIRD_NAME, SOURCE_SYS, REMARK, UPDATE_DT)
values ('0816020000', '非银行金融机构', '0816020000', '非存款类', '0816020000', '非银行金融机构', 'wind', null, null);

commit;