/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a68tszfsdiskno
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a68tszfsdiskno
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a68tszfsdiskno purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a68tszfsdiskno(
    diskno varchar2(24) -- 定期业务批次号
    ,magbrn varchar2(9) -- 提交网点号
    ,oprtlr varchar2(15) -- 操作柜员
    ,chktlr varchar2(15) -- 复核柜员
    ,unitcd varchar2(90) -- 单位代码
    ,cntrno varchar2(90) -- 协议号
    ,tempacct varchar2(48) -- 单位代码对应帐号
    ,pckno varchar2(30) -- pkg包类型号
    ,txtpcd varchar2(8) -- 业务类型(行外)
    ,txcd varchar2(18) -- 业务编号
    ,transdt varchar2(12) -- 批次提出日期
    ,deadline varchar2(5) -- 回执期限
    ,rtrltd varchar2(12) -- 回执日期
    ,backdate varchar2(12) -- 生成客户回盘日期(贷记业务是提出磁盘日期的下一工作日,借记业务是回执最后期限的下一工作日)
    ,status varchar2(2) -- 批次行外提出状态z 录入未完成 b 已录入 a 复核未完成 a 已复核 q 已组包待发送 s 已成功发送 t 已完成
    ,innerstatus varchar2(2) -- 批次行内提出状态z 录入未完成 b 已录入 a 复核未完成 a 已复核 t 已完成
    ,totalnum varchar2(12) -- 批次总笔数
    ,totalamt varchar2(26) -- 批次总金额
    ,succeedtotalnum varchar2(12) -- 总的成功笔数
    ,succeedtotalamt varchar2(26) -- 总的成功金额
    ,innertotalnum varchar2(12) -- 行内总笔数
    ,innertotalamt varchar2(26) -- 行内总金额
    ,innersucceedtotalnum varchar2(12) -- 行内成功总笔数
    ,innersucceedtotalamt varchar2(26) -- 行内成功总金额
    ,outertotalnum varchar2(12) -- 行外总笔数
    ,outertotalamt varchar2(26) -- 行外总金额
    ,outersucceedtotalnum varchar2(12) -- 行外成功总笔数
    ,outersucceedtotalamt varchar2(26) -- 行外成功总金额
    ,opennode varchar2(9) -- 单位代码对应开户行号
    ,corpacct varchar2(48) -- 企业帐号
    ,corpname varchar2(90) -- 企业帐号户名
    ,message varchar2(375) -- 返回信息
    ,hostdate varchar2(12) -- 主机日期
    ,hostnbr varchar2(18) -- 主机流水
    ,itmscd varchar2(8) -- 费项代码
    ,pmtitmnm varchar2(36) -- 费项简称
    ,ctrctchckflg varchar2(2) -- 是否已检查协议 1：检查通过
    ,cdtrnmflg varchar2(2) -- 收款方是否带户名标志 0:带户名 1:不带户名
    ,areacd varchar2(12) -- 地区代码
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
grant select on ${iol_schema}.mpcs_a68tszfsdiskno to ${iml_schema};
grant select on ${iol_schema}.mpcs_a68tszfsdiskno to ${icl_schema};
grant select on ${iol_schema}.mpcs_a68tszfsdiskno to ${idl_schema};
grant select on ${iol_schema}.mpcs_a68tszfsdiskno to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a68tszfsdiskno is '深同城定期往帐批次登记表';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.diskno is '定期业务批次号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.magbrn is '提交网点号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.oprtlr is '操作柜员';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.chktlr is '复核柜员';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.unitcd is '单位代码';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.cntrno is '协议号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.tempacct is '单位代码对应帐号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.pckno is 'pkg包类型号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.txtpcd is '业务类型(行外)';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.txcd is '业务编号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.transdt is '批次提出日期';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.deadline is '回执期限';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.rtrltd is '回执日期';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.backdate is '生成客户回盘日期(贷记业务是提出磁盘日期的下一工作日,借记业务是回执最后期限的下一工作日)';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.status is '批次行外提出状态z 录入未完成 b 已录入 a 复核未完成 a 已复核 q 已组包待发送 s 已成功发送 t 已完成';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.innerstatus is '批次行内提出状态z 录入未完成 b 已录入 a 复核未完成 a 已复核 t 已完成';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.totalnum is '批次总笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.totalamt is '批次总金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.succeedtotalnum is '总的成功笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.succeedtotalamt is '总的成功金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.innertotalnum is '行内总笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.innertotalamt is '行内总金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.innersucceedtotalnum is '行内成功总笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.innersucceedtotalamt is '行内成功总金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.outertotalnum is '行外总笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.outertotalamt is '行外总金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.outersucceedtotalnum is '行外成功总笔数';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.outersucceedtotalamt is '行外成功总金额';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.opennode is '单位代码对应开户行号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.corpacct is '企业帐号';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.corpname is '企业帐号户名';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.message is '返回信息';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.hostdate is '主机日期';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.hostnbr is '主机流水';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.itmscd is '费项代码';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.pmtitmnm is '费项简称';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.ctrctchckflg is '是否已检查协议 1：检查通过';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.cdtrnmflg is '收款方是否带户名标志 0:带户名 1:不带户名';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.areacd is '地区代码';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a68tszfsdiskno.etl_timestamp is 'ETL处理时间戳';
