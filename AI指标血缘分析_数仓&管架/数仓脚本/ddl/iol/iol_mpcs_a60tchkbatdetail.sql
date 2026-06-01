/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a60tchkbatdetail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a60tchkbatdetail
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a60tchkbatdetail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a60tchkbatdetail(
    trannbr varchar2(12) -- 交易流水号
    ,trandate varchar2(12) -- 交易日期
    ,trantime varchar2(9) -- 交易时间
    ,batdt varchar2(12) -- 批次日期
    ,batno varchar2(30) -- 批次号
    ,batseqno varchar2(30) -- 批次序号
    ,trancode varchar2(6) -- 交易码
    ,linkid number(22,0) -- 链路id
    ,bnakcode varchar2(18) -- 银行代码
    ,identype varchar2(6) -- 证件类型
    ,idennbr varchar2(30) -- 证件号码
    ,nationality varchar2(5) -- 国家代码
    ,cltname varchar2(45) -- 证件姓名
    ,issueoffice varchar2(75) -- 签发机构
    ,photoname varchar2(120) -- 相片文件名
    ,chkresult varchar2(3) -- 验证结果
    ,status varchar2(2) -- s：验证成功t：验证失败w：初始状态
    ,srcseqno varchar2(75) -- 报文流水号
    ,srcsysid varchar2(15) -- 系统id
    ,tlrno varchar2(12) -- 交易代码
    ,brcno varchar2(9) -- 机构号
    ,checkchnl varchar2(2) -- 核查通道0-人行1-国证通2-本地
    ,recordstat varchar2(2) -- 记录状态0-无效1-有效
    ,checkdept varchar2(15) -- 核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部10-汕头分行银行部
    ,checktype varchar2(3) -- 核查类型
    ,photo varchar2(4000) -- 照片流
    ,businesstype varchar2(3) -- 业务种类
    ,trantype varchar2(6) -- 交易类型
    ,chkrspmsg varchar2(450) -- 核查结果信息
    ,transeqno varchar2(105) -- 中台流水
    ,loadflg varchar2(2) -- 导出标识：0-初始化；1-已导出；2-导出中
    ,dealflg varchar2(2) -- 处理标识：0-未处理；1-已核查；2-核查中
    ,feecntflg varchar2(2) -- 费用统计标识：0-未统计；1-已统计
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
grant select on ${iol_schema}.mpcs_a60tchkbatdetail to ${iml_schema};
grant select on ${iol_schema}.mpcs_a60tchkbatdetail to ${icl_schema};
grant select on ${iol_schema}.mpcs_a60tchkbatdetail to ${idl_schema};
grant select on ${iol_schema}.mpcs_a60tchkbatdetail to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a60tchkbatdetail is '批量联网核查信息表';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.trannbr is '交易流水号';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.trandate is '交易日期';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.trantime is '交易时间';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.batdt is '批次日期';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.batno is '批次号';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.batseqno is '批次序号';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.trancode is '交易码';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.linkid is '链路id';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.bnakcode is '银行代码';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.identype is '证件类型';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.idennbr is '证件号码';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.nationality is '国家代码';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.cltname is '证件姓名';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.issueoffice is '签发机构';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.photoname is '相片文件名';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.chkresult is '验证结果';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.status is 's：验证成功t：验证失败w：初始状态';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.srcseqno is '报文流水号';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.srcsysid is '系统id';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.tlrno is '交易代码';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.brcno is '机构号';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.checkchnl is '核查通道0-人行1-国证通2-本地';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.recordstat is '记录状态0-无效1-有效';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.checkdept is '核查部门1-互联网银行事业部2-个人银行部3-公司银行部4-零售信贷部5-金融市场部6-授信审批部7-微贷产品事业部8-交易银行部9-同业银行部10-汕头分行银行部';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.checktype is '核查类型';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.photo is '照片流';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.businesstype is '业务种类';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.trantype is '交易类型';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.chkrspmsg is '核查结果信息';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.transeqno is '中台流水';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.loadflg is '导出标识：0-初始化；1-已导出；2-导出中';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.dealflg is '处理标识：0-未处理；1-已核查；2-核查中';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.feecntflg is '费用统计标识：0-未统计；1-已统计';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.mpcs_a60tchkbatdetail.etl_timestamp is 'ETL处理时间戳';
