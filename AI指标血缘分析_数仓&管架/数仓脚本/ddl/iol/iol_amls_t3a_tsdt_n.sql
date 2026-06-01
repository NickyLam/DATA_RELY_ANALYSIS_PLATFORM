/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3a_tsdt_n
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3a_tsdt_n
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3a_tsdt_n purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3a_tsdt_n(
    rpt_id varchar2(96) -- 报告编号
    ,stat_dt date -- 数据日期
    ,cbif_seq number(22) -- 客户序号
    ,crcd varchar2(6) -- 大额交易特征代码
    ,tsdt_seq number(22) -- 交易序号
    ,atif_seq number(22) -- 账户序号
    ,htcr_seq number(22) -- 特征序号
    ,finc varchar2(24) -- 金融机构网点代码
    ,rlfc varchar2(3) -- 金融机构与客户的关系
    ,tbnm varchar2(192) -- 交易代办人姓名
    ,tbit varchar2(9) -- 交易代办人身份证件/证明文件类型
    ,tb_oitp varchar2(192) -- 其他身份证件/证明文件类型
    ,tbid varchar2(192) -- 交易代办人身份证件/证明文件号码
    ,tbnt varchar2(5) -- 交易代办人国籍
    ,tstm varchar2(21) -- 交易时间
    ,trcd varchar2(14) -- 交易发生地
    ,ticd varchar2(384) -- 业务标识号
    ,rpmt varchar2(3) -- 收付款方匹配号类型
    ,rpmn varchar2(750) -- 收付款方匹配号
    ,tstp varchar2(9) -- 交易方式
    ,octt varchar2(3) -- 非柜台交易方式
    ,ooct varchar2(96) -- 其他非柜台交易方式
    ,ocec varchar2(750) -- 非柜台交易方式的设备代码
    ,bptc varchar2(750) -- 银行与支付机构之间的业务交易编码
    ,tsct varchar2(24) -- 涉外收支交易分类与代码(参见表t1p_tsct)
    ,tsdr varchar2(3) -- 资金收付标志
    ,crpp varchar2(768) -- 资金用途
    ,crtp varchar2(5) -- 交易币种
    ,crat number(22) -- 交易金额
    ,cfin varchar2(192) -- 对方金融机构网点名称
    ,cfct varchar2(3) -- 对方金融机构网点代码类型
    ,cfic varchar2(24) -- 对方金融机构网点代码
    ,cfrc varchar2(14) -- 对方金融机构网点行政区划代码
    ,tcnm varchar2(192) -- 交易对手姓名/名称
    ,tcit varchar2(9) -- 交易对手身份证件/证明文件类型
    ,tc_oitp varchar2(192) -- 其他身份证件/证明文件类型
    ,tcid varchar2(192) -- 交易对手身份证件/证明文件号码
    ,tcat varchar2(9) -- 交易对手账户类型
    ,tcac varchar2(96) -- 交易对手账号
    ,rotf1 varchar2(384) -- 交易信息备注1
    ,rotf2 varchar2(384) -- 交易信息备注2
    ,bh_valid varchar2(2) -- 大额验证（参见[字典:AML0041]）
    ,cust_id varchar2(48) -- 客户编号
    ,cust_type varchar2(2) -- 客户类型（参见[字典:AML0030]）
    ,tr_dt date -- 交易日期
    ,tr_org_id varchar2(30) -- 交易机构
    ,is_cash varchar2(3) -- 现转标志（参见[字典:AML0034]）
    ,is_local_curr varchar2(2) -- 本外币标志（参见[字典:AML0015]）
    ,tr_amt number(22) -- 原币交易金额
    ,debit_credit varchar2(2) -- 借贷标志（参见[字典:AML0035]）
    ,acct_id varchar2(96) -- 账号
    ,main_acct_id varchar2(96) -- 主客户账号
    ,card_no varchar2(96) -- 银行卡卡号
    ,rpdt varchar2(12) -- 报告生成日期
    ,err_type varchar2(2) -- 错误类型
    ,pbc_rcpt_tm varchar2(21) -- 人行回执时间
    ,crmb number(22) -- 交易金额（折人民币）
    ,cusd number(22) -- 交易金额（折美元）
    ,ccif_seq number(22) -- 交易客户序号
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
grant select on ${iol_schema}.amls_t3a_tsdt_n to ${iml_schema};
grant select on ${iol_schema}.amls_t3a_tsdt_n to ${icl_schema};
grant select on ${iol_schema}.amls_t3a_tsdt_n to ${idl_schema};
grant select on ${iol_schema}.amls_t3a_tsdt_n to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3a_tsdt_n is '大额新增报告交易信息';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rpt_id is '报告编号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cbif_seq is '客户序号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.crcd is '大额交易特征代码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tsdt_seq is '交易序号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.atif_seq is '账户序号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.htcr_seq is '特征序号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.finc is '金融机构网点代码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rlfc is '金融机构与客户的关系';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tbnm is '交易代办人姓名';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tbit is '交易代办人身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tb_oitp is '其他身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tbid is '交易代办人身份证件/证明文件号码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tbnt is '交易代办人国籍';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tstm is '交易时间';
comment on column ${iol_schema}.amls_t3a_tsdt_n.trcd is '交易发生地';
comment on column ${iol_schema}.amls_t3a_tsdt_n.ticd is '业务标识号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rpmt is '收付款方匹配号类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rpmn is '收付款方匹配号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tstp is '交易方式';
comment on column ${iol_schema}.amls_t3a_tsdt_n.octt is '非柜台交易方式';
comment on column ${iol_schema}.amls_t3a_tsdt_n.ooct is '其他非柜台交易方式';
comment on column ${iol_schema}.amls_t3a_tsdt_n.ocec is '非柜台交易方式的设备代码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.bptc is '银行与支付机构之间的业务交易编码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tsct is '涉外收支交易分类与代码(参见表t1p_tsct)';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tsdr is '资金收付标志';
comment on column ${iol_schema}.amls_t3a_tsdt_n.crpp is '资金用途';
comment on column ${iol_schema}.amls_t3a_tsdt_n.crtp is '交易币种';
comment on column ${iol_schema}.amls_t3a_tsdt_n.crat is '交易金额';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cfin is '对方金融机构网点名称';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cfct is '对方金融机构网点代码类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cfic is '对方金融机构网点代码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cfrc is '对方金融机构网点行政区划代码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tcnm is '交易对手姓名/名称';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tcit is '交易对手身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tc_oitp is '其他身份证件/证明文件类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tcid is '交易对手身份证件/证明文件号码';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tcat is '交易对手账户类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tcac is '交易对手账号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rotf1 is '交易信息备注1';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rotf2 is '交易信息备注2';
comment on column ${iol_schema}.amls_t3a_tsdt_n.bh_valid is '大额验证（参见[字典:AML0041]）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cust_id is '客户编号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cust_type is '客户类型（参见[字典:AML0030]）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tr_dt is '交易日期';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tr_org_id is '交易机构';
comment on column ${iol_schema}.amls_t3a_tsdt_n.is_cash is '现转标志（参见[字典:AML0034]）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.is_local_curr is '本外币标志（参见[字典:AML0015]）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.tr_amt is '原币交易金额';
comment on column ${iol_schema}.amls_t3a_tsdt_n.debit_credit is '借贷标志（参见[字典:AML0035]）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.acct_id is '账号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.main_acct_id is '主客户账号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.card_no is '银行卡卡号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.rpdt is '报告生成日期';
comment on column ${iol_schema}.amls_t3a_tsdt_n.err_type is '错误类型';
comment on column ${iol_schema}.amls_t3a_tsdt_n.pbc_rcpt_tm is '人行回执时间';
comment on column ${iol_schema}.amls_t3a_tsdt_n.crmb is '交易金额（折人民币）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.cusd is '交易金额（折美元）';
comment on column ${iol_schema}.amls_t3a_tsdt_n.ccif_seq is '交易客户序号';
comment on column ${iol_schema}.amls_t3a_tsdt_n.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t3a_tsdt_n.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t3a_tsdt_n.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t3a_tsdt_n.etl_timestamp is 'ETL处理时间戳';
