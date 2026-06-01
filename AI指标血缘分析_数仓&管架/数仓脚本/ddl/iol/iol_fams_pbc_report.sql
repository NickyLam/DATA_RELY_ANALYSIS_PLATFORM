/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_pbc_report
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_pbc_report
whenever sqlerror continue none;
drop table ${iol_schema}.fams_pbc_report purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_pbc_report(
    reportuuid varchar2(72) -- 主键
    ,termid varchar2(40) -- 期数
    ,reporttype varchar2(40) -- 报表类型:
    ,startdate date -- 开始日期
    ,enddate date -- 结束日期
    ,issue_party_id varchar2(100) -- 发行机构代码
    ,issue_party_name varchar2(100) -- 发行机构名称
    ,reportfrequ varchar2(4) -- 报表频率：D-日，WE-周报，M-月报，S-季，Y-年
    ,report_org_name varchar2(1000) -- 填报机构名称
    ,social_credit_code varchar2(100) -- 社会信用代码
    ,fin_institution_code varchar2(100) -- 金融机构编码
    ,prod_variety varchar2(100) -- 产品品种
    ,person_liable varchar2(100) -- 责任人
    ,contact varchar2(100) -- 联系方式
    ,report_date date -- 制表日期
    ,submit_time date -- 报送日期
    ,chb_submit_deadline date -- 中债报送截止日
    ,submit_deadline date -- 行内报送截止日
    ,submit_feedback_status varchar2(100) -- 返回信息
    ,status varchar2(100) -- 有效状态
    ,send_status varchar2(40) -- 报送状态
    ,status_date date -- 数据日期
    ,create_user varchar2(40) -- 创建人
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,org_code varchar2(40) -- 机构代码
    ,dept_code varchar2(40) -- 部门代码
    ,create_dept varchar2(64) -- 创建部门
    ,pbc_account_id varchar2(100) -- 资产池代码
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
grant select on ${iol_schema}.fams_pbc_report to ${iml_schema};
grant select on ${iol_schema}.fams_pbc_report to ${icl_schema};
grant select on ${iol_schema}.fams_pbc_report to ${idl_schema};
grant select on ${iol_schema}.fams_pbc_report to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_pbc_report is '人行报表';
comment on column ${iol_schema}.fams_pbc_report.reportuuid is '主键';
comment on column ${iol_schema}.fams_pbc_report.termid is '期数';
comment on column ${iol_schema}.fams_pbc_report.reporttype is '报表类型:';
comment on column ${iol_schema}.fams_pbc_report.startdate is '开始日期';
comment on column ${iol_schema}.fams_pbc_report.enddate is '结束日期';
comment on column ${iol_schema}.fams_pbc_report.issue_party_id is '发行机构代码';
comment on column ${iol_schema}.fams_pbc_report.issue_party_name is '发行机构名称';
comment on column ${iol_schema}.fams_pbc_report.reportfrequ is '报表频率：D-日，WE-周报，M-月报，S-季，Y-年';
comment on column ${iol_schema}.fams_pbc_report.report_org_name is '填报机构名称';
comment on column ${iol_schema}.fams_pbc_report.social_credit_code is '社会信用代码';
comment on column ${iol_schema}.fams_pbc_report.fin_institution_code is '金融机构编码';
comment on column ${iol_schema}.fams_pbc_report.prod_variety is '产品品种';
comment on column ${iol_schema}.fams_pbc_report.person_liable is '责任人';
comment on column ${iol_schema}.fams_pbc_report.contact is '联系方式';
comment on column ${iol_schema}.fams_pbc_report.report_date is '制表日期';
comment on column ${iol_schema}.fams_pbc_report.submit_time is '报送日期';
comment on column ${iol_schema}.fams_pbc_report.chb_submit_deadline is '中债报送截止日';
comment on column ${iol_schema}.fams_pbc_report.submit_deadline is '行内报送截止日';
comment on column ${iol_schema}.fams_pbc_report.submit_feedback_status is '返回信息';
comment on column ${iol_schema}.fams_pbc_report.status is '有效状态';
comment on column ${iol_schema}.fams_pbc_report.send_status is '报送状态';
comment on column ${iol_schema}.fams_pbc_report.status_date is '数据日期';
comment on column ${iol_schema}.fams_pbc_report.create_user is '创建人';
comment on column ${iol_schema}.fams_pbc_report.create_time is '创建时间';
comment on column ${iol_schema}.fams_pbc_report.update_user is '更新人';
comment on column ${iol_schema}.fams_pbc_report.update_time is '更新时间';
comment on column ${iol_schema}.fams_pbc_report.org_code is '机构代码';
comment on column ${iol_schema}.fams_pbc_report.dept_code is '部门代码';
comment on column ${iol_schema}.fams_pbc_report.create_dept is '创建部门';
comment on column ${iol_schema}.fams_pbc_report.pbc_account_id is '资产池代码';
comment on column ${iol_schema}.fams_pbc_report.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.fams_pbc_report.etl_timestamp is 'ETL处理时间戳';
