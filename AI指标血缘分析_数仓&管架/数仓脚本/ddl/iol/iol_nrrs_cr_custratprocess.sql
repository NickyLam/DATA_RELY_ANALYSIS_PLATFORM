/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nrrs_cr_custratprocess
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nrrs_cr_custratprocess
whenever sqlerror continue none;
drop table ${iol_schema}.nrrs_cr_custratprocess purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nrrs_cr_custratprocess(
    faud varchar2(30) -- 序号
    ,lsh varchar2(30) -- 评级流水号
    ,rattype varchar2(1) -- 评级类型
    ,custid varchar2(30) -- 客户编号
    ,operatorid varchar2(20) -- 操作员
    ,deptcode varchar2(20) -- 所属机构
    ,role_id varchar2(100) -- 岗位角色
    ,ratdate varchar2(10) -- 处理日期
    ,gettype varchar2(1) -- 结果产生方式
    ,risklevel varchar2(4) -- 评级级别
    ,compname varchar2(100) -- 外部评级公司名称
    ,outratedta varchar2(10) -- 外部评级日期
    ,outrateenddta varchar2(10) -- 外部评级截止日期
    ,overthing varchar2(2) -- 推翻事由
    ,reason varchar2(2) -- 暂无评级原因
    ,audittype varchar2(1) -- 意见类型
    ,opinion varchar2(500) -- 意见说明
    ,auditdate varchar2(10) -- 审核日期
    ,auditdateend varchar2(10) -- 审核截止日期
    ,uselsh varchar2(30) -- 最新使用评级流水号
    ,newestflag varchar2(1) -- 最新标志
    ,year varchar2(6) -- 评级报表年月
    ,reportid varchar2(10) -- 报告编号
    ,lastestdhrisklevel varchar2(4) -- 最新贷后评级级别
    ,lastestzsrisklevel varchar2(4) -- 最新正式评级级别
    ,isreferconreport varchar2(1) -- 是否参考合并报表结果
    ,conreportlsh varchar2(30) -- 合并报表结果对应流水号
    ,conreportstate varchar2(1) -- 合并报表评级状态
    ,ratlook varchar2(1) -- 评级展望
    ,outrisklevel varchar2(4) -- 外部级别
    ,overturn varchar2(1) -- 是否推翻
    ,lastfaud varchar2(30) -- 上一岗位序号
    ,exbron varchar2(5) -- 业务标示
    ,ratertype varchar2(2) -- 评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级
    ,maincustomerid varchar2(32) -- 借款人客户号
    ,applyserialno varchar2(32) -- 所属授信号
    ,busicode varchar2(32) -- 业务品种
    ,fslx varchar2(32) -- 发生类型
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.nrrs_cr_custratprocess to ${iml_schema};
grant select on ${iol_schema}.nrrs_cr_custratprocess to ${icl_schema};
grant select on ${iol_schema}.nrrs_cr_custratprocess to ${idl_schema};

-- comment
comment on table ${iol_schema}.nrrs_cr_custratprocess is '评级流程表';
comment on column ${iol_schema}.nrrs_cr_custratprocess.faud is '序号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.lsh is '评级流水号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.rattype is '评级类型';
comment on column ${iol_schema}.nrrs_cr_custratprocess.custid is '客户编号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.operatorid is '操作员';
comment on column ${iol_schema}.nrrs_cr_custratprocess.deptcode is '所属机构';
comment on column ${iol_schema}.nrrs_cr_custratprocess.role_id is '岗位角色';
comment on column ${iol_schema}.nrrs_cr_custratprocess.ratdate is '处理日期';
comment on column ${iol_schema}.nrrs_cr_custratprocess.gettype is '结果产生方式';
comment on column ${iol_schema}.nrrs_cr_custratprocess.risklevel is '评级级别';
comment on column ${iol_schema}.nrrs_cr_custratprocess.compname is '外部评级公司名称';
comment on column ${iol_schema}.nrrs_cr_custratprocess.outratedta is '外部评级日期';
comment on column ${iol_schema}.nrrs_cr_custratprocess.outrateenddta is '外部评级截止日期';
comment on column ${iol_schema}.nrrs_cr_custratprocess.overthing is '推翻事由';
comment on column ${iol_schema}.nrrs_cr_custratprocess.reason is '暂无评级原因';
comment on column ${iol_schema}.nrrs_cr_custratprocess.audittype is '意见类型';
comment on column ${iol_schema}.nrrs_cr_custratprocess.opinion is '意见说明';
comment on column ${iol_schema}.nrrs_cr_custratprocess.auditdate is '审核日期';
comment on column ${iol_schema}.nrrs_cr_custratprocess.auditdateend is '审核截止日期';
comment on column ${iol_schema}.nrrs_cr_custratprocess.uselsh is '最新使用评级流水号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.newestflag is '最新标志';
comment on column ${iol_schema}.nrrs_cr_custratprocess.year is '评级报表年月';
comment on column ${iol_schema}.nrrs_cr_custratprocess.reportid is '报告编号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.lastestdhrisklevel is '最新贷后评级级别';
comment on column ${iol_schema}.nrrs_cr_custratprocess.lastestzsrisklevel is '最新正式评级级别';
comment on column ${iol_schema}.nrrs_cr_custratprocess.isreferconreport is '是否参考合并报表结果';
comment on column ${iol_schema}.nrrs_cr_custratprocess.conreportlsh is '合并报表结果对应流水号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.conreportstate is '合并报表评级状态';
comment on column ${iol_schema}.nrrs_cr_custratprocess.ratlook is '评级展望';
comment on column ${iol_schema}.nrrs_cr_custratprocess.outrisklevel is '外部级别';
comment on column ${iol_schema}.nrrs_cr_custratprocess.overturn is '是否推翻';
comment on column ${iol_schema}.nrrs_cr_custratprocess.lastfaud is '上一岗位序号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.exbron is '业务标示';
comment on column ${iol_schema}.nrrs_cr_custratprocess.ratertype is '评级对象类型 01 借款人评级 02 保证人评级  03 集团下属成员评级';
comment on column ${iol_schema}.nrrs_cr_custratprocess.maincustomerid is '借款人客户号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.applyserialno is '所属授信号';
comment on column ${iol_schema}.nrrs_cr_custratprocess.busicode is '业务品种';
comment on column ${iol_schema}.nrrs_cr_custratprocess.fslx is '发生类型';
comment on column ${iol_schema}.nrrs_cr_custratprocess.start_dt is '开始时间';
comment on column ${iol_schema}.nrrs_cr_custratprocess.end_dt is '结束时间';
comment on column ${iol_schema}.nrrs_cr_custratprocess.id_mark is '增删标志';
comment on column ${iol_schema}.nrrs_cr_custratprocess.etl_timestamp is 'ETL处理时间戳';
