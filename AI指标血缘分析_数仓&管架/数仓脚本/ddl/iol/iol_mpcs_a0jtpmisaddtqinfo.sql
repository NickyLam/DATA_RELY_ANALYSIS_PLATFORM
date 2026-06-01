/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0jtpmisaddtqinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0jtpmisaddtqinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0jtpmisaddtqinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0jtpmisaddtqinfo(
    mainseq varchar2(24) -- 中台流水号
    ,transdt varchar2(12) -- 交易日期
    ,trantype varchar2(5) -- 交易类型 1-提钞 2-提钞补录
    ,biz_type_code varchar2(3) -- 业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞
    ,bank_self_num varchar2(75) -- 银行自身流水号
    ,idtype_code varchar2(6) -- 证件类型代码
    ,idcode varchar2(75) -- 证件号码
    ,person_name varchar2(384) -- 姓名
    ,ctycode varchar2(5) -- 国家/地区代码
    ,add_idcode varchar2(75) -- 补充证件号码
    ,biz_tx_chnl_code varchar2(3) -- 业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）
    ,txccy varchar2(5) -- 币种
    ,zq_amt varchar2(27) -- 金额
    ,acct_no varchar2(48) -- 个人外汇账户账号
    ,biz_tx_time varchar2(24) -- 业务办理时间
    ,remark varchar2(768) -- 备注
    ,rein_reason_code varchar2(3) -- 补录原因代码
    ,rein_remark varchar2(384) -- 补录说明
    ,status varchar2(3) -- 交易状态 z 初始状态 0-失败 1-成功 c-已撤销
    ,refno varchar2(75) -- 业务参号
    ,code varchar2(9) -- 返回码
    ,detail varchar2(768) -- 返回信息
    ,tq_amt_date varchar2(27) -- 当日已提取金额（折美元）
    ,tq_amt_year varchar2(27) -- 当年已提取金额（折美元）
    ,src varchar2(9) -- 发起节点代码
    ,des varchar2(14) -- 接收节点代码
    ,sendtime varchar2(30) -- 发送时间
    ,common_org_code varchar2(18) -- 机构代码
    ,msgno varchar2(50) -- 报文参考号
    ,brcno varchar2(12) -- 交易机构
    ,tlrno varchar2(12) -- 交易柜员
    ,srcsysid varchar2(15) -- 渠道
    ,srcseqno varchar2(96) -- 渠道流水号
    ,uptm varchar2(21) -- 更新时间
    ,upbrcno varchar2(12) -- 更新机构
    ,uptlrno varchar2(12) -- 更新柜员
    ,uptype varchar2(12) -- 更新类型 0-查询 1-修改 2-撤销
    ,upreason_code varchar2(12) -- 更新原因代码
    ,upremark varchar2(768) -- 更新原因
    ,uprefno varchar2(75) -- 更新业务参考号
    ,upbank_self_num varchar2(75) -- 更新银行自身流水号
    ,glob_seq_num varchar2(96) -- 全局流水号
    ,unique_seq_num varchar2(96) -- 业务流水号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a0jtpmisaddtqinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddtqinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddtqinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0jtpmisaddtqinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0jtpmisaddtqinfo is '';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.mainseq is '中台流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.trantype is '交易类型 1-提钞 2-提钞补录';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.biz_type_code is '业务类型 02-账户提钞/06-外币兑换外币提取/08-其他提钞';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.bank_self_num is '银行自身流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.idtype_code is '证件类型代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.idcode is '证件号码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.person_name is '姓名';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.ctycode is '国家/地区代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.add_idcode is '补充证件号码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.biz_tx_chnl_code is '业务办理渠道代码 12-柜台渠道（接口模式） 23-自助终端 42-特许兑换机构（接口模式柜台业务） 52-非银行金融机构（接口模式柜台业务）';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.txccy is '币种';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.zq_amt is '金额';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.acct_no is '个人外汇账户账号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.biz_tx_time is '业务办理时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.remark is '备注';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.rein_reason_code is '补录原因代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.rein_remark is '补录说明';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.status is '交易状态 z 初始状态 0-失败 1-成功 c-已撤销';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.refno is '业务参号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.code is '返回码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.detail is '返回信息';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.tq_amt_date is '当日已提取金额（折美元）';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.tq_amt_year is '当年已提取金额（折美元）';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.src is '发起节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.des is '接收节点代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.sendtime is '发送时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.common_org_code is '机构代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.msgno is '报文参考号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.brcno is '交易机构';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.tlrno is '交易柜员';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.srcsysid is '渠道';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.srcseqno is '渠道流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.uptm is '更新时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.upbrcno is '更新机构';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.uptlrno is '更新柜员';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.uptype is '更新类型 0-查询 1-修改 2-撤销';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.upreason_code is '更新原因代码';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.upremark is '更新原因';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.uprefno is '更新业务参考号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.upbank_self_num is '更新银行自身流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0jtpmisaddtqinfo.etl_timestamp is 'ETL处理时间戳';
