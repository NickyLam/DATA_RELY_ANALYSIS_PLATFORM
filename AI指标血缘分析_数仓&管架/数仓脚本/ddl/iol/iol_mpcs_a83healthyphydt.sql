/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a83healthyphydt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a83healthyphydt
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a83healthyphydt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a83healthyphydt(
    transeq varchar2(15) -- 批次号
    ,dealdt varchar2(15) -- 操作日期
    ,no varchar2(15) -- 批次序号
    ,yshacct varchar2(30) -- 映山红卡号
    ,yshclassname varchar2(30) -- 映山红卡等级中文说明
    ,yshclass varchar2(2) -- 映山红卡等级 0-映山红卡 1-映山红钻石卡
    ,ltkacct varchar2(30) -- 龙腾卡卡号
    ,ltkclass varchar2(2) -- 龙腾卡等级 0-白金 1-钻石
    ,custname varchar2(45) -- 用户姓名
    ,idtfno varchar2(30) -- 身份证号
    ,phone varchar2(30) -- 联系电话
    ,content varchar2(45) -- 权益内容
    ,contentoff varchar2(150) -- 权益供应商
    ,orderdt varchar2(15) -- 预约日期
    ,usedt varchar2(15) -- 使用日期
    ,offername varchar2(225) -- 服务机构
    ,remark varchar2(150) -- 备注
    ,brnnbr varchar2(15) -- 申请机构
    ,tlrnbr varchar2(15) -- 申请柜员
    ,remark1 varchar2(150) -- 0-下单成 1-已取消 2-已使用
    ,remark2 varchar2(150) -- 
    ,remark3 varchar2(750) -- 
    ,remark4 varchar2(750) -- 
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
grant select on ${iol_schema}.mpcs_a83healthyphydt to ${iml_schema};
grant select on ${iol_schema}.mpcs_a83healthyphydt to ${icl_schema};
grant select on ${iol_schema}.mpcs_a83healthyphydt to ${idl_schema};
grant select on ${iol_schema}.mpcs_a83healthyphydt to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a83healthyphydt is '健康体检导入明细表';
comment on column ${iol_schema}.mpcs_a83healthyphydt.transeq is '批次号';
comment on column ${iol_schema}.mpcs_a83healthyphydt.dealdt is '操作日期';
comment on column ${iol_schema}.mpcs_a83healthyphydt.no is '批次序号';
comment on column ${iol_schema}.mpcs_a83healthyphydt.yshacct is '映山红卡号';
comment on column ${iol_schema}.mpcs_a83healthyphydt.yshclassname is '映山红卡等级中文说明';
comment on column ${iol_schema}.mpcs_a83healthyphydt.yshclass is '映山红卡等级 0-映山红卡 1-映山红钻石卡';
comment on column ${iol_schema}.mpcs_a83healthyphydt.ltkacct is '龙腾卡卡号';
comment on column ${iol_schema}.mpcs_a83healthyphydt.ltkclass is '龙腾卡等级 0-白金 1-钻石';
comment on column ${iol_schema}.mpcs_a83healthyphydt.custname is '用户姓名';
comment on column ${iol_schema}.mpcs_a83healthyphydt.idtfno is '身份证号';
comment on column ${iol_schema}.mpcs_a83healthyphydt.phone is '联系电话';
comment on column ${iol_schema}.mpcs_a83healthyphydt.content is '权益内容';
comment on column ${iol_schema}.mpcs_a83healthyphydt.contentoff is '权益供应商';
comment on column ${iol_schema}.mpcs_a83healthyphydt.orderdt is '预约日期';
comment on column ${iol_schema}.mpcs_a83healthyphydt.usedt is '使用日期';
comment on column ${iol_schema}.mpcs_a83healthyphydt.offername is '服务机构';
comment on column ${iol_schema}.mpcs_a83healthyphydt.remark is '备注';
comment on column ${iol_schema}.mpcs_a83healthyphydt.brnnbr is '申请机构';
comment on column ${iol_schema}.mpcs_a83healthyphydt.tlrnbr is '申请柜员';
comment on column ${iol_schema}.mpcs_a83healthyphydt.remark1 is '0-下单成 1-已取消 2-已使用';
comment on column ${iol_schema}.mpcs_a83healthyphydt.remark2 is '';
comment on column ${iol_schema}.mpcs_a83healthyphydt.remark3 is '';
comment on column ${iol_schema}.mpcs_a83healthyphydt.remark4 is '';
comment on column ${iol_schema}.mpcs_a83healthyphydt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a83healthyphydt.etl_timestamp is 'ETL处理时间戳';
