/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dsvp_seal_custaccount
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dsvp_seal_custaccount
whenever sqlerror continue none;
drop table ${iol_schema}.dsvp_seal_custaccount purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_seal_custaccount(
    dbserno number -- 编号
    ,accountno varchar2(32) -- 账号
    ,sealcardno varchar2(8) -- 印鉴卡序号
    ,areano varchar2(4) -- 地区代码
    ,oldcardno varchar2(8) -- 旧印鉴卡序号
    ,cardprintno varchar2(32) -- 印鉴卡号
    ,branchno varchar2(100) -- 机构编号
    ,siteno varchar2(60) -- 建模机构编号
    ,subjectno varchar2(60) -- 科目编号
    ,name varchar2(200) -- 账户名称
    ,address varchar2(400) -- 地址
    ,postcode varchar2(6) -- 邮政编号
    ,noteex varchar2(2000) -- 备注
    ,contactman varchar2(60) -- 联系人
    ,contactphone varchar2(30) -- 联系电话
    ,email varchar2(100) -- 邮箱
    ,personalid varchar2(64) -- 身份证编号
    ,quality number(38,0) -- 通兑标识（1-通存通兑，2-非通存通兑）
    ,type number(38,0) -- 预留字段0
    ,monittype number(38,0) -- 监控标识（0-正常，1-监控户，2-关注户）
    ,opendate date -- 开户日期
    ,destroydate date -- 销户日期
    ,operator varchar2(32) -- 员工编号
    ,checker varchar2(32) -- 员工编号
    ,sealcount number(38,0) -- 印章数量
    ,siteid number(38,0) -- 节点号
    ,createdate date -- 建模日期
    ,usedate date -- 启用日期
    ,stopdate date -- 停用日期
    ,drawoutdate date -- 抽卡日期
    ,state number(38,0) -- 印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）
    ,checkflag number(38,0) -- 复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）
    ,destroyflag number(38,0) -- 销户标识（0-正常，1-销户）
    ,loseflag number(38,0) -- 挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）
    ,acctproperty number(38,0) -- 账户性质
    ,billtype varchar2(3) -- 币种编号
    ,flagfield varchar2(35) -- 标识域
    ,suspectnote varchar2(300) -- 监控备注
    ,mainaccno varchar2(32) -- 主账号
    ,reservedchar1 varchar2(1024) -- 预留字段1
    ,reservedchar2 varchar2(32) -- 退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）
    ,reservedchar3 varchar2(300) -- 退回理由
    ,reservedchar4 varchar2(1024) -- 预留字段4
    ,belongflag number(38,0) -- 共用标识（0-非共用，1-主账户，2-从账户）
    ,password varchar2(32) -- 密码
    ,workdate date -- 工作日期
    ,systemdate timestamp -- 系统日期
    ,verifycombination varchar2(400) -- 验印组合
    ,datamac varchar2(17) -- 数据MAC
    ,imgmac varchar2(17) -- 图像MAC
    ,imglen number(38,0) -- 图像大小
    ,sealimages varchar2(4000) -- 印章信息
    ,standbyamount number(20,2) -- 保证金金额
    ,accountstate varchar2(2) -- 账户状态
    ,prescanimageid varchar2(32) -- 图像编号
    ,prescanflag number(38,0) -- 采集标识（0-否，1-是）
    ,printcount number(38,0) -- 打印次数
    ,modifyflag number(38,0) -- 修改标识（0-未校验，1-已校验）
    ,custno varchar2(22) -- 核心客户号
    ,custname varchar2(600) -- 客户名称
    ,other1 varchar2(1024) -- 预留字段3
    ,other2 varchar2(1024) -- 预留字段4
    ,other3 varchar2(1024) -- 预留字段5
    ,checkbranchno varchar2(60) -- 复核机构编号
    ,collectbranchno varchar2(60) -- 采集机构编号
    ,precollectflag number(38,0) -- 预采集标识
    ,acctype varchar2(6) -- 账户类型
    ,qualitybranch varchar2(60) -- 指定机构通兑
    ,freezedate date -- 挂失日志————--借用冻结日期
    ,freezeflag number(38,0) -- 
    ,open_user varchar2(12) -- 账户的开户柜员号
    ,rebuild_combo varchar2(64) -- 重建验印组合标志（"0"-非重建组合 "1"-重建组合）
    ,card_status varchar2(12) -- 最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)
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
grant select on ${iol_schema}.dsvp_seal_custaccount to ${iml_schema};
grant select on ${iol_schema}.dsvp_seal_custaccount to ${icl_schema};
grant select on ${iol_schema}.dsvp_seal_custaccount to ${idl_schema};
grant select on ${iol_schema}.dsvp_seal_custaccount to ${iel_schema};

-- comment
comment on table ${iol_schema}.dsvp_seal_custaccount is '印鉴信息表';
comment on column ${iol_schema}.dsvp_seal_custaccount.dbserno is '编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.accountno is '账号';
comment on column ${iol_schema}.dsvp_seal_custaccount.sealcardno is '印鉴卡序号';
comment on column ${iol_schema}.dsvp_seal_custaccount.areano is '地区代码';
comment on column ${iol_schema}.dsvp_seal_custaccount.oldcardno is '旧印鉴卡序号';
comment on column ${iol_schema}.dsvp_seal_custaccount.cardprintno is '印鉴卡号';
comment on column ${iol_schema}.dsvp_seal_custaccount.branchno is '机构编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.siteno is '建模机构编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.subjectno is '科目编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.name is '账户名称';
comment on column ${iol_schema}.dsvp_seal_custaccount.address is '地址';
comment on column ${iol_schema}.dsvp_seal_custaccount.postcode is '邮政编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.noteex is '备注';
comment on column ${iol_schema}.dsvp_seal_custaccount.contactman is '联系人';
comment on column ${iol_schema}.dsvp_seal_custaccount.contactphone is '联系电话';
comment on column ${iol_schema}.dsvp_seal_custaccount.email is '邮箱';
comment on column ${iol_schema}.dsvp_seal_custaccount.personalid is '身份证编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.quality is '通兑标识（1-通存通兑，2-非通存通兑）';
comment on column ${iol_schema}.dsvp_seal_custaccount.type is '预留字段0';
comment on column ${iol_schema}.dsvp_seal_custaccount.monittype is '监控标识（0-正常，1-监控户，2-关注户）';
comment on column ${iol_schema}.dsvp_seal_custaccount.opendate is '开户日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.destroydate is '销户日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.operator is '员工编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.checker is '员工编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.sealcount is '印章数量';
comment on column ${iol_schema}.dsvp_seal_custaccount.siteid is '节点号';
comment on column ${iol_schema}.dsvp_seal_custaccount.createdate is '建模日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.usedate is '启用日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.stopdate is '停用日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.drawoutdate is '抽卡日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.state is '印鉴卡状态（0-使用卡，1-临时卡，2-已抽卡）';
comment on column ${iol_schema}.dsvp_seal_custaccount.checkflag is '复核标识（0-开户未复核，1-已复核，2-重建未复核，3-变更未复核）';
comment on column ${iol_schema}.dsvp_seal_custaccount.destroyflag is '销户标识（0-正常，1-销户）';
comment on column ${iol_schema}.dsvp_seal_custaccount.loseflag is '挂失标识（0-正常，1-公章挂失，2-预留印鉴挂失，3-公章+预留印鉴挂失）';
comment on column ${iol_schema}.dsvp_seal_custaccount.acctproperty is '账户性质';
comment on column ${iol_schema}.dsvp_seal_custaccount.billtype is '币种编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.flagfield is '标识域';
comment on column ${iol_schema}.dsvp_seal_custaccount.suspectnote is '监控备注';
comment on column ${iol_schema}.dsvp_seal_custaccount.mainaccno is '主账号';
comment on column ${iol_schema}.dsvp_seal_custaccount.reservedchar1 is '预留字段1';
comment on column ${iol_schema}.dsvp_seal_custaccount.reservedchar2 is '退回标识（1-开户复核退回，2-变更复核退回，3-重建复核退回）';
comment on column ${iol_schema}.dsvp_seal_custaccount.reservedchar3 is '退回理由';
comment on column ${iol_schema}.dsvp_seal_custaccount.reservedchar4 is '预留字段4';
comment on column ${iol_schema}.dsvp_seal_custaccount.belongflag is '共用标识（0-非共用，1-主账户，2-从账户）';
comment on column ${iol_schema}.dsvp_seal_custaccount.password is '密码';
comment on column ${iol_schema}.dsvp_seal_custaccount.workdate is '工作日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.systemdate is '系统日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.verifycombination is '验印组合';
comment on column ${iol_schema}.dsvp_seal_custaccount.datamac is '数据MAC';
comment on column ${iol_schema}.dsvp_seal_custaccount.imgmac is '图像MAC';
comment on column ${iol_schema}.dsvp_seal_custaccount.imglen is '图像大小';
comment on column ${iol_schema}.dsvp_seal_custaccount.sealimages is '印章信息';
comment on column ${iol_schema}.dsvp_seal_custaccount.standbyamount is '保证金金额';
comment on column ${iol_schema}.dsvp_seal_custaccount.accountstate is '账户状态';
comment on column ${iol_schema}.dsvp_seal_custaccount.prescanimageid is '图像编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.prescanflag is '采集标识（0-否，1-是）';
comment on column ${iol_schema}.dsvp_seal_custaccount.printcount is '打印次数';
comment on column ${iol_schema}.dsvp_seal_custaccount.modifyflag is '修改标识（0-未校验，1-已校验）';
comment on column ${iol_schema}.dsvp_seal_custaccount.custno is '核心客户号';
comment on column ${iol_schema}.dsvp_seal_custaccount.custname is '客户名称';
comment on column ${iol_schema}.dsvp_seal_custaccount.other1 is '预留字段3';
comment on column ${iol_schema}.dsvp_seal_custaccount.other2 is '预留字段4';
comment on column ${iol_schema}.dsvp_seal_custaccount.other3 is '预留字段5';
comment on column ${iol_schema}.dsvp_seal_custaccount.checkbranchno is '复核机构编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.collectbranchno is '采集机构编号';
comment on column ${iol_schema}.dsvp_seal_custaccount.precollectflag is '预采集标识';
comment on column ${iol_schema}.dsvp_seal_custaccount.acctype is '账户类型';
comment on column ${iol_schema}.dsvp_seal_custaccount.qualitybranch is '指定机构通兑';
comment on column ${iol_schema}.dsvp_seal_custaccount.freezedate is '挂失日志————--借用冻结日期';
comment on column ${iol_schema}.dsvp_seal_custaccount.freezeflag is '';
comment on column ${iol_schema}.dsvp_seal_custaccount.open_user is '账户的开户柜员号';
comment on column ${iol_schema}.dsvp_seal_custaccount.rebuild_combo is '重建验印组合标志（"0"-非重建组合 "1"-重建组合）';
comment on column ${iol_schema}.dsvp_seal_custaccount.card_status is '最新卡状态(NULL-正常 1-主/非共用销户 2-从销户/脱离需变更)';
comment on column ${iol_schema}.dsvp_seal_custaccount.start_dt is '开始时间';
comment on column ${iol_schema}.dsvp_seal_custaccount.end_dt is '结束时间';
comment on column ${iol_schema}.dsvp_seal_custaccount.id_mark is '增删标志';
comment on column ${iol_schema}.dsvp_seal_custaccount.etl_timestamp is 'ETL处理时间戳';
