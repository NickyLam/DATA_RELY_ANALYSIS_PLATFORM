/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol osbs_cpr_trade_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.osbs_cpr_trade_flow
whenever sqlerror continue none;
drop table ${iol_schema}.osbs_cpr_trade_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.osbs_cpr_trade_flow(
    ctf_trade_flowno varchar2(32) -- 流水号
    ,ctf_transtime varchar2(17) -- 交易时间
    ,ctf_transdate varchar2(8) -- 交易日期
    ,ctf_transcode varchar2(64) -- 交易码
    ,ctf_action varchar2(64) -- 请求do
    ,ctf_ecifno varchar2(32) -- 全行统一客户号
    ,ctf_userno varchar2(32) -- 用户顺序号
    ,ctf_channel varchar2(16) -- 交易渠道
    ,ctf_ecifname varchar2(256) -- 客户姓名
    ,ctf_menuid varchar2(100) -- 
    ,ctf_state varchar2(2) -- 交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)
    ,ctf_returncode varchar2(400) -- 交易返回码
    ,ctf_returnmsg varchar2(1024) -- 失败原因
    ,ctf_accno varchar2(40) -- 交易账号
    ,ctf_amonut number(15,2) -- 交易金额
    ,ctf_currency varchar2(3) -- 币种
    ,ctf_sendflowno varchar2(1000) -- 渠道发送流水号
    ,ctf_src_sendflowno varchar2(64) -- 源系统流水号
    ,ctf_hostflowno varchar2(64) -- 核心交易流水号
    ,ctf_fee number(15,2) -- 手续费
    ,ctf_parentlogno varchar2(32) -- 父流水号
    ,ctf_rootlogno varchar2(32) -- 来源流水顺序号
    ,ctf_authrefusecause varchar2(128) -- 授权拒绝原因
    ,ctf_accessflowno varchar2(32) -- 访问流水号
    ,ctf_host_returntime varchar2(14) -- 核心交易日期
    ,ctf_svrtranscode varchar2(100) -- 被调方交易编码
    ,ctf_customerip varchar2(256) -- 客户IP
    ,ctf_hostname varchar2(50) -- 当前服务器主机名
    ,ctf_src_serverip varchar2(32) -- 请求来源服务器IP
    ,ctf_clientmac varchar2(24) -- 客户终端MAC地址
    ,ctf_clientos varchar2(30) -- 客户终端操作系统
    ,ctf_clientbrowser varchar2(60) -- 客户终端浏览器
    ,ctf_clientnunittype varchar2(30) -- 客户终端设备型号
    ,ctf_clientterminateno varchar2(60) -- 客户终端设备ID
    ,ctf_sessionid varchar2(120) -- 登陆sessionID
    ,ctf_relflowno varchar2(32) -- 关联流水号
    ,ctf_securitytype varchar2(1) -- 安全认证方式
    ,ctf_authstate varchar2(1) -- 授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)
    ,ctf_delegateflag varchar2(1) -- 是否银行代办(N:非;Y:是)
    ,ctf_authstep varchar2(1) -- 授权角色编号
    ,ctf_senddate varchar2(8) -- 交易真正提交核心的日期
    ,ctf_sendtime varchar2(17) -- 交易真正提交核心的时间
    ,ctf_totalcount number -- 交易总笔数
    ,ctf_remark varchar2(512) -- 摘要
    ,ctf_authflag varchar2(1) -- 1:手机OA录入授权模式,0:网银PC录入授权模式
    ,ctf_authtype varchar2(1) -- 授权类型 1:交易授权; 2:管理授权
    ,ctf_applogintype varchar2(5) -- 1.0：手机版；2.0：旧网银；3.0：新网银
    ,ctf_biz_flow_no varchar2(64) -- 业务流水号
    ,ctf_chain_track_no varchar2(64) -- 链路跟踪号
    ,ctf_send_flow_no varchar2(64) -- 上游交易流水号
    ,ctf_faceno varchar2(64) -- 人脸识别流水(有值则需要人脸识别)
    ,ctf_imei varchar2(32) -- 手机串号
    ,ctf_udid varchar2(64) -- 手机SIM
    ,ctf_sim varchar2(16) -- 
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
grant select on ${iol_schema}.osbs_cpr_trade_flow to ${iml_schema};
grant select on ${iol_schema}.osbs_cpr_trade_flow to ${icl_schema};
grant select on ${iol_schema}.osbs_cpr_trade_flow to ${idl_schema};
grant select on ${iol_schema}.osbs_cpr_trade_flow to ${iel_schema};

-- comment
comment on table ${iol_schema}.osbs_cpr_trade_flow is '交易流水表';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_trade_flowno is '流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_transtime is '交易时间';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_transdate is '交易日期';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_transcode is '交易码';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_action is '请求do';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_ecifno is '全行统一客户号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_userno is '用户顺序号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_channel is '交易渠道';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_ecifname is '客户姓名';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_menuid is '';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_state is '交易状态(30: 待授权;31: 待落地审核;41: 管控审核中;42: 管控审核拒绝;50: 交易初始状态;51: 交易处理中;52: 授权处理中;53: 交易成功，次日到账;90: 交易成功;91: 通讯异常;92: 交易异常;93: 交易撤销;94: 授权拒绝;95: 已失效（未及时授权）;96: 落地审核拒绝;98: 状态未明;99: 交易失败;)';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_returncode is '交易返回码';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_returnmsg is '失败原因';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_accno is '交易账号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_amonut is '交易金额';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_currency is '币种';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_sendflowno is '渠道发送流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_src_sendflowno is '源系统流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_hostflowno is '核心交易流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_fee is '手续费';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_parentlogno is '父流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_rootlogno is '来源流水顺序号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_authrefusecause is '授权拒绝原因';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_accessflowno is '访问流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_host_returntime is '核心交易日期';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_svrtranscode is '被调方交易编码';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_customerip is '客户IP';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_hostname is '当前服务器主机名';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_src_serverip is '请求来源服务器IP';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_clientmac is '客户终端MAC地址';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_clientos is '客户终端操作系统';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_clientbrowser is '客户终端浏览器';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_clientnunittype is '客户终端设备型号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_clientterminateno is '客户终端设备ID';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_sessionid is '登陆sessionID';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_relflowno is '关联流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_securitytype is '安全认证方式';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_authstate is '授权状态(空:待授权;0:授权同意;1:交易撤销;2:已失效;9:授权拒绝)';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_delegateflag is '是否银行代办(N:非;Y:是)';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_authstep is '授权角色编号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_senddate is '交易真正提交核心的日期';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_sendtime is '交易真正提交核心的时间';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_totalcount is '交易总笔数';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_remark is '摘要';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_authflag is '1:手机OA录入授权模式,0:网银PC录入授权模式';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_authtype is '授权类型 1:交易授权; 2:管理授权';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_applogintype is '1.0：手机版；2.0：旧网银；3.0：新网银';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_biz_flow_no is '业务流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_chain_track_no is '链路跟踪号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_send_flow_no is '上游交易流水号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_faceno is '人脸识别流水(有值则需要人脸识别)';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_imei is '手机串号';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_udid is '手机SIM';
comment on column ${iol_schema}.osbs_cpr_trade_flow.ctf_sim is '';
comment on column ${iol_schema}.osbs_cpr_trade_flow.start_dt is '开始时间';
comment on column ${iol_schema}.osbs_cpr_trade_flow.end_dt is '结束时间';
comment on column ${iol_schema}.osbs_cpr_trade_flow.id_mark is '增删标志';
comment on column ${iol_schema}.osbs_cpr_trade_flow.etl_timestamp is 'ETL处理时间戳';
