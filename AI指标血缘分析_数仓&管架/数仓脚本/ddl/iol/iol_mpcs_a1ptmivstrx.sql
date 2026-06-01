/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1ptmivstrx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1ptmivstrx
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1ptmivstrx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1ptmivstrx(
    transdt varchar2(12) -- 交易日期
    ,transtm varchar2(12) -- 交易时间
    ,pckno varchar2(30) -- 报文类型
    ,sndbrn varchar2(21) -- 发送行
    ,sndupbrn varchar2(21) -- 发送清算行
    ,rcvbrn varchar2(21) -- 接收行
    ,rcvupbrn varchar2(21) -- 接收清算行
    ,consigndt varchar2(12) -- 委托日期
    ,transseq varchar2(53) -- 报文标识号
    ,msgrefid varchar2(53) -- 通信级参考号
    ,iotype varchar2(2) -- 来往标识 0-往 1-来
    ,mobnb varchar2(20) -- 手机号
    ,entprs varchar2(2) -- 市场主体类型码
    ,nm varchar2(450) -- 名称
    ,nmoflglprsn varchar2(600) -- 法定代表人或单位负责人姓名
    ,tranm varchar2(768) -- 字号名称
    ,idtp varchar2(6) -- 证件类型
    ,id varchar2(53) -- 证件号
    ,unisoccdtcd varchar2(27) -- 统一社会信用代码
    ,bizregnb varchar2(27) -- 工商注册号
    ,txpyridnb varchar2(30) -- 纳税人识别号
    ,agtnm varchar2(420) -- 代理人姓名
    ,agtid varchar2(53) -- 代理人身份证件号码
    ,opnm varchar2(420) -- 操作员姓名
    ,margbrn varchar2(15) -- 处理机构
    ,tlrno varchar2(15) -- 处理柜员
    ,srcseqno varchar2(105) -- 渠道流水
    ,sysind varchar2(6) -- 核查系统标识
    ,quedt varchar2(12) -- 系统受理查询日期
    ,acctsts varchar2(6) -- 企业账户状态：OPEN：已开户 CLOS：已销户
    ,chngdt varchar2(12) -- 企业账户状态变更日期
    ,orgdlvrgtransseq varchar2(53) -- 疑义反馈原报文标识号
    ,cntt varchar2(768) -- 疑义反馈内容
    ,contactnm varchar2(420) -- 联系人姓名
    ,contactnb varchar2(45) -- 联系人电话
    ,rcvdt varchar2(12) -- 接收日期
    ,rcvtm varchar2(9) -- 接收时间
    ,msgid varchar2(53) -- 回执报文标识号
    ,procsts varchar2(6) -- 人行处理状态
    ,proccd varchar2(12) -- 人行处理码
    ,rslt varchar2(6) -- 核查结果
    ,mobcrr varchar2(6) -- 手机运营商
    ,locmobnb varchar2(15) -- 手机号归属地代码
    ,cdtp varchar2(6) -- 客户类型
    ,locnmmobnb varchar2(15) -- 手机号归属地名称
    ,sts varchar2(6) -- 手机号码状态
    ,dataresrcdt varchar2(18) -- 数据源日期
    ,cotp varchar2(384) -- 市场主体类型
    ,dom varchar2(1536) -- 住所
    ,regcptl varchar2(33) -- 注册资本(金)
    ,dtest varchar2(12) -- 成立日期
    ,opprdfrom varchar2(12) -- 经营期限自
    ,opprdto varchar2(12) -- 经营期限至
    ,regsts varchar2(384) -- 登记状态
    ,regauth varchar2(384) -- 登记机关
    ,bizscp varchar2(4000) -- 经营范围
    ,dtappr varchar2(12) -- 核准日期
    ,status varchar2(2) -- 状态 Z-初始登记 S-已发送人行待回执 U-发送人行失败或者超时 T-人行已回执成功 R-被人行拒绝 E-交易失败
    ,errmsg varchar2(768) -- 错误信息
    ,appendtable varchar2(75) -- 附加数据表名
    ,lastpgind varchar2(8) -- 最后一页指示符:true-最后一页 ；false-不是最后一页
    ,ttlpgnb varchar2(8) -- 总页数
    ,curpgnb varchar2(8) -- 当前页数
    ,vrytp varchar2(6) -- 身份核查类型
    ,valtp varchar2(6) -- 身份证有效期类型
    ,issdt varchar2(12) -- 有效期起始日期
    ,exprdt varchar2(12) -- 有效期截止日期
    ,piclen varchar2(12) -- 照片数据长度
    ,picfile varchar2(300) -- 照片存放位置
    ,picvryrslt varchar2(6) -- 人像核查结果
    ,picchkinf varchar2(600) -- 人像核查结果描述
    ,simsco varchar2(12) -- 人像比对分值
    ,busclass varchar2(30) -- 业务大类
    ,busclassdes varchar2(150) -- 业务大类名称
    ,subclass varchar2(30) -- 业务小类
    ,subclassdes varchar2(150) -- 业务小类名称
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
grant select on ${iol_schema}.mpcs_a1ptmivstrx to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1ptmivstrx to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1ptmivstrx to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1ptmivstrx to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1ptmivstrx is '企业联网核查交易明细表';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.transdt is '交易日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.transtm is '交易时间';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.pckno is '报文类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.sndbrn is '发送行';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.sndupbrn is '发送清算行';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.rcvbrn is '接收行';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.rcvupbrn is '接收清算行';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.consigndt is '委托日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.transseq is '报文标识号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.msgrefid is '通信级参考号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.iotype is '来往标识 0-往 1-来';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.mobnb is '手机号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.entprs is '市场主体类型码';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.nm is '名称';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.nmoflglprsn is '法定代表人或单位负责人姓名';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.tranm is '字号名称';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.idtp is '证件类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.id is '证件号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.unisoccdtcd is '统一社会信用代码';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.bizregnb is '工商注册号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.txpyridnb is '纳税人识别号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.agtnm is '代理人姓名';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.agtid is '代理人身份证件号码';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.opnm is '操作员姓名';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.margbrn is '处理机构';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.tlrno is '处理柜员';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.srcseqno is '渠道流水';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.sysind is '核查系统标识';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.quedt is '系统受理查询日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.acctsts is '企业账户状态：OPEN：已开户 CLOS：已销户';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.chngdt is '企业账户状态变更日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.orgdlvrgtransseq is '疑义反馈原报文标识号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.cntt is '疑义反馈内容';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.contactnm is '联系人姓名';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.contactnb is '联系人电话';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.rcvdt is '接收日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.rcvtm is '接收时间';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.msgid is '回执报文标识号';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.procsts is '人行处理状态';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.proccd is '人行处理码';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.rslt is '核查结果';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.mobcrr is '手机运营商';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.locmobnb is '手机号归属地代码';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.cdtp is '客户类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.locnmmobnb is '手机号归属地名称';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.sts is '手机号码状态';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.dataresrcdt is '数据源日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.cotp is '市场主体类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.dom is '住所';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.regcptl is '注册资本(金)';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.dtest is '成立日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.opprdfrom is '经营期限自';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.opprdto is '经营期限至';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.regsts is '登记状态';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.regauth is '登记机关';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.bizscp is '经营范围';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.dtappr is '核准日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.status is '状态 Z-初始登记 S-已发送人行待回执 U-发送人行失败或者超时 T-人行已回执成功 R-被人行拒绝 E-交易失败';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.errmsg is '错误信息';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.appendtable is '附加数据表名';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.lastpgind is '最后一页指示符:true-最后一页 ；false-不是最后一页';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.ttlpgnb is '总页数';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.curpgnb is '当前页数';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.vrytp is '身份核查类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.valtp is '身份证有效期类型';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.issdt is '有效期起始日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.exprdt is '有效期截止日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.piclen is '照片数据长度';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.picfile is '照片存放位置';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.picvryrslt is '人像核查结果';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.picchkinf is '人像核查结果描述';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.simsco is '人像比对分值';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.busclass is '业务大类';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.busclassdes is '业务大类名称';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.subclass is '业务小类';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.subclassdes is '业务小类名称';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a1ptmivstrx.etl_timestamp is 'ETL处理时间戳';
