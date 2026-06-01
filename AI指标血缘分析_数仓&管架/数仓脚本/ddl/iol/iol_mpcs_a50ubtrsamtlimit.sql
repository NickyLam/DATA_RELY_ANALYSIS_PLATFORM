/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubtrsamtlimit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubtrsamtlimit
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubtrsamtlimit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubtrsamtlimit(
    chnlid varchar2(15) -- 交易渠道
    ,product varchar2(30) -- 产品类型 yldoi:银联二维码
    ,custno varchar2(30) -- 客户号
    ,custname varchar2(150) -- 客户名
    ,tokenid varchar2(60) -- 虚拟卡号（如云卡）
    ,acctno varchar2(60) -- 实体卡账户
    ,acctopbk varchar2(30) -- 实体卡所属行号
    ,acctopbkname varchar2(384) -- 实体卡所属行行名
    ,accttype varchar2(3) -- 实体卡类型 00未知 01借记账户 02贷记账户 03准贷记账户 04借贷合一账户 05预付费账户 06半开放预付费账户
    ,addtime varchar2(30) -- 绑卡时间
    ,seqno varchar2(90) -- 绑定流水号
    ,onemamt varchar2(30) -- 小额免密单笔限额
    ,datemamt varchar2(30) -- 小额免密日累计限额
    ,ispwd varchar2(2) -- 免密开关 0-验密 1-免密
    ,maxonetamt varchar2(30) -- 单笔最大交易限额
    ,maxdatetamt varchar2(30) -- 单日累计最大交易限额
    ,maxmonthtamt varchar2(30) -- 单月累计最大交易限额
    ,status varchar2(12) -- 绑卡状态  0-解绑 1-绑定
    ,ghbflag varchar2(3) -- 跨行标志 0-本行 1-他行
    ,tlrno varchar2(15) -- 交易柜员
    ,brchno varchar2(12) -- 交易机构
    ,issinscode varchar2(84) -- 发卡机构代码
    ,ispaycard varchar2(450) -- 默认支付卡标志 1-默认支付卡
    ,msggrade varchar2(15) -- 数据等级 0-客户级 1-账户级
    ,trid varchar2(30) -- 标记请求者id
    ,tokenlevel varchar2(15) -- 标记担保级别
    ,tokenbegin varchar2(30) -- 标记生效时间
    ,tokenend varchar2(30) -- 标记失效时间
    ,tokentype varchar2(15) -- 标记类型
    ,updatetime varchar2(30) -- 变更时间
    ,updateseq varchar2(90) -- 最新更新流水
    ,reserve1 varchar2(120) -- 保留域1
    ,reserve2 varchar2(120) -- 保留域2
    ,reserve3 varchar2(150) -- 保留域3
    ,reserve4 varchar2(150) -- 保留域4
    ,reserve5 varchar2(300) -- 保留域5
    ,reserve6 varchar2(300) -- 保留域6
    ,reserve7 varchar2(384) -- 保留域7
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
grant select on ${iol_schema}.mpcs_a50ubtrsamtlimit to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubtrsamtlimit to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubtrsamtlimit to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubtrsamtlimit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubtrsamtlimit is '限额登记表';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.chnlid is '交易渠道';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.product is '产品类型 yldoi:银联二维码';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.custno is '客户号';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.custname is '客户名';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tokenid is '虚拟卡号（如云卡）';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.acctno is '实体卡账户';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.acctopbk is '实体卡所属行号';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.acctopbkname is '实体卡所属行行名';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.accttype is '实体卡类型 00未知 01借记账户 02贷记账户 03准贷记账户 04借贷合一账户 05预付费账户 06半开放预付费账户';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.addtime is '绑卡时间';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.seqno is '绑定流水号';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.onemamt is '小额免密单笔限额';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.datemamt is '小额免密日累计限额';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.ispwd is '免密开关 0-验密 1-免密';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.maxonetamt is '单笔最大交易限额';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.maxdatetamt is '单日累计最大交易限额';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.maxmonthtamt is '单月累计最大交易限额';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.status is '绑卡状态  0-解绑 1-绑定';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.ghbflag is '跨行标志 0-本行 1-他行';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tlrno is '交易柜员';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.brchno is '交易机构';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.issinscode is '发卡机构代码';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.ispaycard is '默认支付卡标志 1-默认支付卡';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.msggrade is '数据等级 0-客户级 1-账户级';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.trid is '标记请求者id';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tokenlevel is '标记担保级别';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tokenbegin is '标记生效时间';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tokenend is '标记失效时间';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.tokentype is '标记类型';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.updatetime is '变更时间';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.updateseq is '最新更新流水';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve1 is '保留域1';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve2 is '保留域2';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve3 is '保留域3';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve4 is '保留域4';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve5 is '保留域5';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve6 is '保留域6';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.reserve7 is '保留域7';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a50ubtrsamtlimit.etl_timestamp is 'ETL处理时间戳';
