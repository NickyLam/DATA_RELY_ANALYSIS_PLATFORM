/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_trn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_trn
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_trn purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_trn(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 内部唯一ID
    ,inidattim timestamp(6) -- 开立日期
    ,inifrm varchar2(6) -- 交易名
    ,iniusr varchar2(8) -- 用户ID
    ,ininam varchar2(40) -- 交易名
    ,ownref varchar2(16) -- 参考号
    ,objtyp varchar2(6) -- 业务表名称
    ,objinr varchar2(8) -- 业务表INR
    ,objnam varchar2(40) -- 交易对象描述
    ,ssninr varchar2(8) -- 连接 ID
    ,smhnxt number(3) -- 报文、面函个数
    ,usg varchar2(6) -- 操作员组
    ,usr varchar2(8) -- 操作员
    ,cpldattim timestamp(6) -- 完成日期
    ,infdsp varchar2(1) -- 显示信息
    ,inftxt varchar2(264) -- 信息文本
    ,relflg varchar2(1) -- 授权状态
    ,comflg varchar2(1) -- 提交标志
    ,comdat date -- 提交日期
    ,cortrninr varchar2(8) -- 被删除或需要修改的TRN的INR
    ,xreflg varchar2(1) -- 重算标志
    ,xrecurblk varchar2(40) -- 可用货币
    ,relcur varchar2(3) -- 授权币种
    ,relamt number(18,3) -- 授权金额
    ,reloricur varchar2(3) -- 币种
    ,reloriamt number(18,3) -- 金额
    ,relreq varchar2(3) -- 授权请求状态
    ,relres varchar2(3) -- 签名状态
    ,cnfflg varchar2(1) -- 国外确认标志
    ,evttxt varchar2(4000) -- Event事件描述
    ,rprusr varchar2(8) -- 退回到指定人员
    ,ordinr varchar2(8) -- ORD表inr
    ,exedat date -- 执行日期
    ,etyextkey varchar2(8) -- 实体
    ,bchkeyinr varchar2(8) -- 经办机构
    ,accbchinr varchar2(8) -- 记账机构
    ,relreq0 varchar2(3) -- 单证中心授权请求
    ,relreq1 varchar2(3) -- 分行授权请求
    ,relreq2 varchar2(3) -- 支行授权请求
    ,relres0 varchar2(3) -- 单证中心签名
    ,relres1 varchar2(3) -- 分行签名
    ,relres2 varchar2(3) -- 支行签名
    ,relusr1 varchar2(100) -- 授权用户
    ,relusr2 varchar2(8) -- 授权用户
    ,relusr3 varchar2(8) -- 授权用户
    ,imginr varchar2(8) -- 图像inr
    ,branchinr varchar2(8) -- 业务所属支行INR
    ,orgflg varchar2(1) -- 机构标识
    ,addtxt varchar2(264) -- 附加信息
    ,gylsh varchar2(12) -- 核心柜员流水号
    ,gylsh1 varchar2(12) -- 核心表外柜员流水号
    ,yewgzh varchar2(20) -- 业务跟踪号
    ,cmtflg varchar2(1) -- CMT100报文标识
    ,ctrbnknum varchar2(24) -- 对手行行号
    ,ctrbnknam varchar2(40) -- 对手行行名
    ,qjls varchar2(33) -- 全局流水号
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_isbs_trn to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_trn is '交易流水';
comment on column ${idl_schema}.aml_isbs_trn.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_trn.inr is '内部唯一ID';
comment on column ${idl_schema}.aml_isbs_trn.inidattim is '开立日期';
comment on column ${idl_schema}.aml_isbs_trn.inifrm is '交易名';
comment on column ${idl_schema}.aml_isbs_trn.iniusr is '用户ID';
comment on column ${idl_schema}.aml_isbs_trn.ininam is '交易名';
comment on column ${idl_schema}.aml_isbs_trn.ownref is '参考号';
comment on column ${idl_schema}.aml_isbs_trn.objtyp is '业务表名称';
comment on column ${idl_schema}.aml_isbs_trn.objinr is '业务表INR';
comment on column ${idl_schema}.aml_isbs_trn.objnam is '交易对象描述';
comment on column ${idl_schema}.aml_isbs_trn.ssninr is '连接 ID';
comment on column ${idl_schema}.aml_isbs_trn.smhnxt is '报文、面函个数';
comment on column ${idl_schema}.aml_isbs_trn.usg is '操作员组';
comment on column ${idl_schema}.aml_isbs_trn.usr is '操作员';
comment on column ${idl_schema}.aml_isbs_trn.cpldattim is '完成日期';
comment on column ${idl_schema}.aml_isbs_trn.infdsp is '显示信息';
comment on column ${idl_schema}.aml_isbs_trn.inftxt is '信息文本';
comment on column ${idl_schema}.aml_isbs_trn.relflg is '授权状态';
comment on column ${idl_schema}.aml_isbs_trn.comflg is '提交标志';
comment on column ${idl_schema}.aml_isbs_trn.comdat is '提交日期';
comment on column ${idl_schema}.aml_isbs_trn.cortrninr is '被删除或需要修改的TRN的INR';
comment on column ${idl_schema}.aml_isbs_trn.xreflg is '重算标志';
comment on column ${idl_schema}.aml_isbs_trn.xrecurblk is '可用货币';
comment on column ${idl_schema}.aml_isbs_trn.relcur is '授权币种';
comment on column ${idl_schema}.aml_isbs_trn.relamt is '授权金额';
comment on column ${idl_schema}.aml_isbs_trn.reloricur is '币种';
comment on column ${idl_schema}.aml_isbs_trn.reloriamt is '金额';
comment on column ${idl_schema}.aml_isbs_trn.relreq is '授权请求状态';
comment on column ${idl_schema}.aml_isbs_trn.relres is '签名状态';
comment on column ${idl_schema}.aml_isbs_trn.cnfflg is '国外确认标志';
comment on column ${idl_schema}.aml_isbs_trn.evttxt is 'Event事件描述';
comment on column ${idl_schema}.aml_isbs_trn.rprusr is '退回到指定人员';
comment on column ${idl_schema}.aml_isbs_trn.ordinr is 'ORD表inr';
comment on column ${idl_schema}.aml_isbs_trn.exedat is '执行日期';
comment on column ${idl_schema}.aml_isbs_trn.etyextkey is '实体';
comment on column ${idl_schema}.aml_isbs_trn.bchkeyinr is '经办机构';
comment on column ${idl_schema}.aml_isbs_trn.accbchinr is '记账机构';
comment on column ${idl_schema}.aml_isbs_trn.relreq0 is '单证中心授权请求';
comment on column ${idl_schema}.aml_isbs_trn.relreq1 is '分行授权请求';
comment on column ${idl_schema}.aml_isbs_trn.relreq2 is '支行授权请求';
comment on column ${idl_schema}.aml_isbs_trn.relres0 is '单证中心签名';
comment on column ${idl_schema}.aml_isbs_trn.relres1 is '分行签名';
comment on column ${idl_schema}.aml_isbs_trn.relres2 is '支行签名';
comment on column ${idl_schema}.aml_isbs_trn.relusr1 is '授权用户';
comment on column ${idl_schema}.aml_isbs_trn.relusr2 is '授权用户';
comment on column ${idl_schema}.aml_isbs_trn.relusr3 is '授权用户';
comment on column ${idl_schema}.aml_isbs_trn.imginr is '图像inr';
comment on column ${idl_schema}.aml_isbs_trn.branchinr is '业务所属支行INR';
comment on column ${idl_schema}.aml_isbs_trn.orgflg is '机构标识';
comment on column ${idl_schema}.aml_isbs_trn.addtxt is '附加信息';
comment on column ${idl_schema}.aml_isbs_trn.gylsh is '核心柜员流水号';
comment on column ${idl_schema}.aml_isbs_trn.gylsh1 is '核心表外柜员流水号';
comment on column ${idl_schema}.aml_isbs_trn.yewgzh is '业务跟踪号';
comment on column ${idl_schema}.aml_isbs_trn.cmtflg is 'CMT100报文标识';
comment on column ${idl_schema}.aml_isbs_trn.ctrbnknum is '对手行行号';
comment on column ${idl_schema}.aml_isbs_trn.ctrbnknam is '对手行行名';
comment on column ${idl_schema}.aml_isbs_trn.qjls is '全局流水号';
comment on column ${idl_schema}.aml_isbs_trn.etl_timestamp is '数据处理时间';
