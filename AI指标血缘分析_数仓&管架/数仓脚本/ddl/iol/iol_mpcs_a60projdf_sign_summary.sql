/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60projdf_sign_summary
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60projdf_sign_summary
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60projdf_sign_summary purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60projdf_sign_summary(
    projno varchar2(75) -- 项目编号
    ,summsq varchar2(15) -- 批扣流水
    ,bachdt varchar2(12) -- 批次日期
    ,bachsq varchar2(12) -- 批次流水
    ,datfna varchar2(384) -- 批次数据文件名
    ,mmtext varchar2(3) -- 代发摘要
    ,mmcont varchar2(90) -- 自定义摘要
    ,projtp varchar2(3) -- 项目名称  05.代发 00.代扣 09.开卡
    ,payacc varchar2(27) -- 扣款账号
    ,paynam varchar2(384) -- 扣款账号名称
    ,tranno number(22) -- 笔数
    ,tranam number(18,2) -- 总金额
    ,succno number(22) -- 成功笔数
    ,succam number(18,2) -- 成功金额总数
    ,failno number(22) -- 失败笔数
    ,failam number(18,2) -- 失败金额总数
    ,branch varchar2(9) -- 经办网点
    ,tlrnbr varchar2(12) -- 经办柜员
    ,opendcmt varchar2(30) -- 凭证类型
    ,opendcno varchar2(30) -- 起始账号
    ,transt varchar2(2) -- 交易状态 0-未知  1 分析完成  2-发送到核心  3-核心已返回 4-已完成 5-待转账
    ,prtdt varchar2(12) -- 打印日期
    ,chktlr varchar2(12) -- 授权人
    ,transq varchar2(15) -- 交易流水 从核心取
    ,dcmtno varchar2(59) -- 凭证起始号
    ,payadr varchar2(90) -- 单位地址
    ,paytel varchar2(30) -- 单位电话
    ,enflag varchar2(2) -- 加密标志 0 明文 1密文
    ,trflag varchar2(2) -- 辅助标志 transt=0 1读文件 0完成
    ,errmsg varchar2(372) -- 错误信息
    ,iccdfg varchar2(2) -- 芯片标志 0否芯片  1 是芯片
    ,coopcd varchar2(5) -- 
    ,agstyp varchar2(3) -- 电话激活标志
    ,trantp varchar2(2) -- 批量处理交易类型
    ,signst varchar2(2) -- 签约状态 0-处理中 1-处理完成
    ,realacctno varchar2(30) -- 实际扣款/收款账号
    ,hostseqno varchar2(18) -- 核心交易流水
    ,hostdt varchar2(12) -- 核心交易日期
    ,transeqno varchar2(60) -- 中台交易流水号(用于销凭证撤销)
    ,cardkind varchar2(30) -- 
    ,proc_times number(22,0) -- 批次处理次数
    ,core_bach_sq varchar2(75) -- 核心返回批次号
    ,isinact varchar2(2) -- 内部户标志
    ,cardpbind varchar2(2) -- 卡bin
    ,prodtype varchar2(30) -- 产品类型
    ,openccy varchar2(15) -- 币种
    ,clienttype varchar2(15) -- 客户类型
    ,categorytype varchar2(18) -- 客户细分类型
    ,withdrawaltype varchar2(5) -- 支取方式
    ,narrativecode varchar2(90) -- 摘要码
    ,contacttype varchar2(90) -- 联系类型
    ,vouchstartno varchar2(90) -- 凭证起始号
    ,batchopentype varchar2(15) -- 批次类型
    ,callstat5 varchar2(2) -- 批量开卡调用核心1400-0150接口状态
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
grant select on ${iol_schema}.mpcs_a60projdf_sign_summary to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_summary to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_summary to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60projdf_sign_summary to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60projdf_sign_summary is '批次总表';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.projno is '项目编号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.summsq is '批扣流水';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.bachdt is '批次日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.bachsq is '批次流水';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.datfna is '批次数据文件名';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.mmtext is '代发摘要';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.mmcont is '自定义摘要';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.projtp is '项目名称  05.代发 00.代扣 09.开卡';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.payacc is '扣款账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.paynam is '扣款账号名称';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.tranno is '笔数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.tranam is '总金额';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.succno is '成功笔数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.succam is '成功金额总数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.failno is '失败笔数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.failam is '失败金额总数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.branch is '经办网点';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.tlrnbr is '经办柜员';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.opendcmt is '凭证类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.opendcno is '起始账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.transt is '交易状态 0-未知  1 分析完成  2-发送到核心  3-核心已返回 4-已完成 5-待转账';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.prtdt is '打印日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.chktlr is '授权人';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.transq is '交易流水 从核心取';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.dcmtno is '凭证起始号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.payadr is '单位地址';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.paytel is '单位电话';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.enflag is '加密标志 0 明文 1密文';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.trflag is '辅助标志 transt=0 1读文件 0完成';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.iccdfg is '芯片标志 0否芯片  1 是芯片';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.coopcd is '';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.agstyp is '电话激活标志';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.trantp is '批量处理交易类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.signst is '签约状态 0-处理中 1-处理完成';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.realacctno is '实际扣款/收款账号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.hostdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.transeqno is '中台交易流水号(用于销凭证撤销)';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.cardkind is '';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.proc_times is '批次处理次数';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.core_bach_sq is '核心返回批次号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.isinact is '内部户标志';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.cardpbind is '卡bin';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.prodtype is '产品类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.openccy is '币种';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.clienttype is '客户类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.categorytype is '客户细分类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.withdrawaltype is '支取方式';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.narrativecode is '摘要码';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.contacttype is '联系类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.vouchstartno is '凭证起始号';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.batchopentype is '批次类型';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.callstat5 is '批量开卡调用核心1400-0150接口状态';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a60projdf_sign_summary.etl_timestamp is 'ETL处理时间戳';
