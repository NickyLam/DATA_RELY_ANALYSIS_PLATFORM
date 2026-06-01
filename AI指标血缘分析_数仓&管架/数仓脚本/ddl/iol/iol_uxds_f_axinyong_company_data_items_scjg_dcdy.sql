/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_axinyong_company_data_items_scjg_dcdy
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,amount varchar2(4000) -- 被担保债权数额
    ,idtype varchar2(4000) -- 抵押权人证照／证件类型
    ,datakeyid varchar2(4000) -- 数据主键id
    ,datatype varchar2(4000) -- 数据类型值
    ,guaranteepurview varchar2(4000) -- 担保范围
    ,remark varchar2(4000) -- 备注
    ,idnumber varchar2(4000) -- 身份证号码
    ,mortgageename varchar2(4000) -- 抵押权人名称
    ,registrationauthority varchar2(4000) -- 登记机关
    ,claimstype varchar2(4000) -- 被担保债权类型
    ,scjg_dcdy varchar2(4000) -- 关联标签
    ,registrationnumber varchar2(4000) -- 登记编号
    ,legalperson varchar2(4000) -- 法定代表人姓名
    ,name varchar2(4000) -- 企业名称
    ,registrationdate varchar2(4000) -- 登记日期
    ,location varchar2(4000) -- 所在地等情况
    ,usccode varchar2(4000) -- 统一社会信用代码
    ,performanceperiod varchar2(4000) -- 债务人履行债务期限
    ,collateral varchar2(4000) -- 抵押物信息
    ,status varchar2(4000) -- 状态
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy to ${iml_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy to ${icl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy to ${idl_schema};
grant select on ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy is '市场监管-动产抵押';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.amount is '被担保债权数额';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.idtype is '抵押权人证照／证件类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.datakeyid is '数据主键id';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.datatype is '数据类型值';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.guaranteepurview is '担保范围';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.remark is '备注';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.idnumber is '身份证号码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.mortgageename is '抵押权人名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.registrationauthority is '登记机关';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.claimstype is '被担保债权类型';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.scjg_dcdy is '关联标签';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.registrationnumber is '登记编号';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.legalperson is '法定代表人姓名';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.name is '企业名称';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.registrationdate is '登记日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.location is '所在地等情况';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.usccode is '统一社会信用代码';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.performanceperiod is '债务人履行债务期限';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.collateral is '抵押物信息';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.status is '状态';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_axinyong_company_data_items_scjg_dcdy.etl_timestamp is 'ETL处理时间戳';
