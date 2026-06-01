/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_f_shell_entinfo_ent_info_basic
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic(
    gendate date -- 生成时间
    ,serialnumber varchar2(4000) -- 业务系统流水号
    ,sequenceid varchar2(4000) -- 系统流水号
    ,ent_info_basic varchar2(4000) -- 关联标签
    ,entname varchar2(4000) -- 企业名称
    ,entname_old varchar2(4000) -- 曾用名
    ,orgcodes varchar2(4000) -- 组织机构代码
    ,creditcode varchar2(4000) -- 统一信用代码
    ,regno varchar2(4000) -- 注册号
    ,frname varchar2(4000) -- 法定代表人/负责人/执行事务合伙人
    ,regcap varchar2(4000) -- 注册资本（企业:万元）
    ,regcapcurcode varchar2(4000) -- 注册资本币种代码
    ,regcapcur varchar2(4000) -- 注册资本币种
    ,esdate varchar2(4000) -- 成立日期
    ,opfrom varchar2(4000) -- 经营期限自
    ,opto varchar2(4000) -- 经营期限至
    ,entitytype varchar2(4000) -- 实体类型
    ,enttype varchar2(4000) -- 企业类型
    ,entstatus varchar2(4000) -- 经营状态
    ,entstatuscode varchar2(4000) -- 经营状态编码
    ,abuitem varchar2(4000) -- 许可经营项目
    ,zsopscope varchar2(4000) -- 经营业务范围
    ,regorg varchar2(4000) -- 登记机关
    ,ancheyear varchar2(4000) -- 最后年检年度
    ,candate varchar2(4000) -- 注销日期
    ,revdate varchar2(4000) -- 吊销日期
    ,apprdate varchar2(4000) -- 核准日期
    ,enttypecode varchar2(4000) -- 企业(机构)类型编码
    ,industrycocode varchar2(4000) -- 工业代码
    ,industryconame varchar2(4000) -- 工业业务
    ,dom varchar2(4000) -- 住址
    ,regorgcode varchar2(4000) -- 注册地址行政编号
    ,regorgprovince varchar2(4000) -- 所在省份
    ,regorgcity varchar2(4000) -- 所在城市
    ,regcity varchar2(4000) -- 所在城市编码
    ,regorgdistrict varchar2(4000) -- 所在区/县
    ,postalcode varchar2(4000) -- 邮编
    ,s_ext_nodenum varchar2(4000) -- 所在省份编码
    ,entid varchar2(4000) -- 企业ENTID
    ,paidincap varchar2(4000) -- 实缴资本(万元)
    ,genmonth varchar2(4000) -- 
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
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic to ${iml_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic to ${icl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic to ${idl_schema};
grant select on ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic is '中数智汇企业基本信息表';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.gendate is '生成时间';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.serialnumber is '业务系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.sequenceid is '系统流水号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.ent_info_basic is '关联标签';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entname is '企业名称';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entname_old is '曾用名';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.orgcodes is '组织机构代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.creditcode is '统一信用代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regno is '注册号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.frname is '法定代表人/负责人/执行事务合伙人';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regcap is '注册资本（企业:万元）';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regcapcurcode is '注册资本币种代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regcapcur is '注册资本币种';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.esdate is '成立日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.opfrom is '经营期限自';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.opto is '经营期限至';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entitytype is '实体类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.enttype is '企业类型';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entstatus is '经营状态';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entstatuscode is '经营状态编码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.abuitem is '许可经营项目';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.zsopscope is '经营业务范围';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regorg is '登记机关';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.ancheyear is '最后年检年度';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.candate is '注销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.revdate is '吊销日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.apprdate is '核准日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.enttypecode is '企业(机构)类型编码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.industrycocode is '工业代码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.industryconame is '工业业务';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.dom is '住址';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regorgcode is '注册地址行政编号';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regorgprovince is '所在省份';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regorgcity is '所在城市';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regcity is '所在城市编码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.regorgdistrict is '所在区/县';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.postalcode is '邮编';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.s_ext_nodenum is '所在省份编码';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.entid is '企业ENTID';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.paidincap is '实缴资本(万元)';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.genmonth is '';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_f_shell_entinfo_ent_info_basic.etl_timestamp is 'ETL处理时间戳';
