/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a50ubcardequip
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a50ubcardequip
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a50ubcardequip purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a50ubcardequip(
    termid varchar2(12) -- 设备id
    ,unit varchar2(12) -- 机构编码
    ,tell varchar2(30) -- 操作员号
    ,addr varchar2(150) -- 设备安装地点
    ,ipaddr varchar2(23) -- 设备ip地址
    ,type varchar2(2) -- 设备类型
    ,lastdate varchar2(15) -- 最后一次开启或关闭时间（yymmddhhmm）
    ,equipstat varchar2(2) -- 设备状态
    ,module1 varchar2(2) -- 模块1状态(币值1状态)
    ,module2 varchar2(2) -- 模块2状态(币值2状态)
    ,module3 varchar2(2) -- 模块3状态(币值3状态)
    ,module4 varchar2(2) -- 模块4状态(币值4状态)
    ,othmod varchar2(6) -- 设备模块状态
    ,sflag varchar2(2) -- 签到标志
    ,trskey varchar2(96) -- 传输密钥
    ,filldate varchar2(15) -- 上次补钞日期时间
    ,lastaddamt number(11,2) -- 最后一次补钞尾箱余额
    ,currvalue1 number(6,2) -- 币值1面值
    ,currvalue2 number(6,2) -- 币值2面值
    ,currvalue3 number(6,2) -- 币值3面值
    ,currvalue4 number(6,2) -- 币值4面值
    ,lastfill1 number(4,0) -- atm上次币值1补钞数
    ,lastfill2 number(4,0) -- atm上次币值2补钞数
    ,lastfill3 number(4,0) -- atm上次币值3补钞数
    ,lastfill4 number(4,0) -- atm上次币值3补钞数
    ,periprst1 number(4,0) -- atm补钞周期币值1出钞数/cdm币值1存钞数
    ,periprst2 number(4,0) -- atm补钞周期币值2出钞数/cdm币值2存钞数
    ,periprst3 number(4,0) -- atm补钞周期币值3出钞数/cdm币值3存钞数
    ,periprst4 number(4,0) -- atm补钞周期币值4出钞数/cdm币值4存钞数
    ,cutdate varchar2(15) -- 上次日终时间
    ,cutprst1 number(4,0) -- 日终周期币值1出入钞数
    ,cutprst2 number(4,0) -- 日终周期币值2出入钞数
    ,cutprst3 number(4,0) -- 日终周期币值3出入钞数
    ,cutprst4 number(4,0) -- 日终周期币值4出入钞数
    ,cwdnum number(4,0) -- 日终周期取款数
    ,cwdsum number(11,2) -- 日终周期取款金额
    ,depnum number(4,0) -- 日终周期存款数
    ,depsum number(11,2) -- 日终周期存款金额
    ,tfrnum number(4,0) -- 日终周期转帐数
    ,tfrsum number(11,2) -- 日终周期转帐金额
    ,cardret number(4,0) -- 日终周期吞卡数
    ,zmkey varchar2(96) -- 本地主密钥
    ,zakey varchar2(96) -- mac工作密钥
    ,machinekey varchar2(9) -- 装机码
    ,devtype varchar2(90) -- 设备型号
    ,begindatetime varchar2(21) -- 验证有效期：开始时间
    ,enddatetime varchar2(21) -- 验证有效期：结束时间
    ,remainno varchar2(3) -- 重试次数
    ,lastopttime varchar2(21) -- 上次操作时间
    ,awayflag varchar2(2) -- 离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点
    ,worktype varchar2(2) -- 经营方式 1-自营 2-联营
    ,setuptype varchar2(2) -- 安装方式 0-穿墙 1-大堂
    ,cashboxlimit varchar2(75) -- 钱箱报警金额
    ,devservice number(10,0) -- 设备维护商
    ,serial varchar2(60) -- 设备序列号
    ,startdate varchar2(12) -- 设备启用日期
    ,stopdate varchar2(12) -- 设备停用日期
    ,expiredate varchar2(12) -- 保修到期日期
    ,patrolperiod number(10,0) -- 巡检周期 单位/天
    ,powerontime varchar2(9) -- 每日开机时间
    ,powerdowntime varchar2(9) -- 每日关机时间
    ,atmcsoft varchar2(75) -- atmc软件
    ,packetsize number(10,0) -- 传输包大小 有线设备初始8000 无线设备初始256
    ,nettype varchar2(2) -- 联网类型 c：cable有线 w：wireless无线
    ,selfbanktype varchar2(2) -- 自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备
    ,devcatalog number(38,0) -- 设备属性
    ,devvendor number(38,0) -- 设备品牌
    ,installdate varchar2(15) -- 设备安装日期
    ,atmparea varchar2(15) -- 银联标准地区代码
    ,brnname varchar2(120) -- 机构名称
    ,buydate varchar2(15) -- 购机日期
    ,enctype varchar2(2) -- 加密方式 0-国密 1或空非国密
    ,authcode varchar2(72) -- 申请主密钥认证码(8位装机码)
    ,status varchar2(2) -- 
    ,apltlrname varchar2(120) -- 申请柜员名字
    ,applydate varchar2(30) -- 申请加钞日期
    ,applyteller varchar2(30) -- 申请加钞柜员
    ,atmcashboxno varchar2(30) -- atm机尾箱号
    ,cashboxno varchar2(30) -- 加钞尾箱号
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
grant select on ${iol_schema}.mpcs_a50ubcardequip to ${iml_schema};
grant select on ${iol_schema}.mpcs_a50ubcardequip to ${icl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardequip to ${idl_schema};
grant select on ${iol_schema}.mpcs_a50ubcardequip to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a50ubcardequip is 'ATM设备信息表';
comment on column ${iol_schema}.mpcs_a50ubcardequip.termid is '设备id';
comment on column ${iol_schema}.mpcs_a50ubcardequip.unit is '机构编码';
comment on column ${iol_schema}.mpcs_a50ubcardequip.tell is '操作员号';
comment on column ${iol_schema}.mpcs_a50ubcardequip.addr is '设备安装地点';
comment on column ${iol_schema}.mpcs_a50ubcardequip.ipaddr is '设备ip地址';
comment on column ${iol_schema}.mpcs_a50ubcardequip.type is '设备类型';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastdate is '最后一次开启或关闭时间（yymmddhhmm）';
comment on column ${iol_schema}.mpcs_a50ubcardequip.equipstat is '设备状态';
comment on column ${iol_schema}.mpcs_a50ubcardequip.module1 is '模块1状态(币值1状态)';
comment on column ${iol_schema}.mpcs_a50ubcardequip.module2 is '模块2状态(币值2状态)';
comment on column ${iol_schema}.mpcs_a50ubcardequip.module3 is '模块3状态(币值3状态)';
comment on column ${iol_schema}.mpcs_a50ubcardequip.module4 is '模块4状态(币值4状态)';
comment on column ${iol_schema}.mpcs_a50ubcardequip.othmod is '设备模块状态';
comment on column ${iol_schema}.mpcs_a50ubcardequip.sflag is '签到标志';
comment on column ${iol_schema}.mpcs_a50ubcardequip.trskey is '传输密钥';
comment on column ${iol_schema}.mpcs_a50ubcardequip.filldate is '上次补钞日期时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastaddamt is '最后一次补钞尾箱余额';
comment on column ${iol_schema}.mpcs_a50ubcardequip.currvalue1 is '币值1面值';
comment on column ${iol_schema}.mpcs_a50ubcardequip.currvalue2 is '币值2面值';
comment on column ${iol_schema}.mpcs_a50ubcardequip.currvalue3 is '币值3面值';
comment on column ${iol_schema}.mpcs_a50ubcardequip.currvalue4 is '币值4面值';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastfill1 is 'atm上次币值1补钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastfill2 is 'atm上次币值2补钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastfill3 is 'atm上次币值3补钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastfill4 is 'atm上次币值3补钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.periprst1 is 'atm补钞周期币值1出钞数/cdm币值1存钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.periprst2 is 'atm补钞周期币值2出钞数/cdm币值2存钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.periprst3 is 'atm补钞周期币值3出钞数/cdm币值3存钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.periprst4 is 'atm补钞周期币值4出钞数/cdm币值4存钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cutdate is '上次日终时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cutprst1 is '日终周期币值1出入钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cutprst2 is '日终周期币值2出入钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cutprst3 is '日终周期币值3出入钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cutprst4 is '日终周期币值4出入钞数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cwdnum is '日终周期取款数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cwdsum is '日终周期取款金额';
comment on column ${iol_schema}.mpcs_a50ubcardequip.depnum is '日终周期存款数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.depsum is '日终周期存款金额';
comment on column ${iol_schema}.mpcs_a50ubcardequip.tfrnum is '日终周期转帐数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.tfrsum is '日终周期转帐金额';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cardret is '日终周期吞卡数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.zmkey is '本地主密钥';
comment on column ${iol_schema}.mpcs_a50ubcardequip.zakey is 'mac工作密钥';
comment on column ${iol_schema}.mpcs_a50ubcardequip.machinekey is '装机码';
comment on column ${iol_schema}.mpcs_a50ubcardequip.devtype is '设备型号';
comment on column ${iol_schema}.mpcs_a50ubcardequip.begindatetime is '验证有效期：开始时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.enddatetime is '验证有效期：结束时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.remainno is '重试次数';
comment on column ${iol_schema}.mpcs_a50ubcardequip.lastopttime is '上次操作时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.awayflag is '离行在行标志 1-在行自助服务区 2-单机离行自助服务点(自营) 3-离行自助银行(自营)-非银亭 4-离行自助银行(自营)-银亭 5-单机离行自助服务点(联营) 6-离行自助银行(联营)-非银亭 7-离行自助银行(联营)-银亭 8-单机在行自助服务点';
comment on column ${iol_schema}.mpcs_a50ubcardequip.worktype is '经营方式 1-自营 2-联营';
comment on column ${iol_schema}.mpcs_a50ubcardequip.setuptype is '安装方式 0-穿墙 1-大堂';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cashboxlimit is '钱箱报警金额';
comment on column ${iol_schema}.mpcs_a50ubcardequip.devservice is '设备维护商';
comment on column ${iol_schema}.mpcs_a50ubcardequip.serial is '设备序列号';
comment on column ${iol_schema}.mpcs_a50ubcardequip.startdate is '设备启用日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.stopdate is '设备停用日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.expiredate is '保修到期日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.patrolperiod is '巡检周期 单位/天';
comment on column ${iol_schema}.mpcs_a50ubcardequip.powerontime is '每日开机时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.powerdowntime is '每日关机时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.atmcsoft is 'atmc软件';
comment on column ${iol_schema}.mpcs_a50ubcardequip.packetsize is '传输包大小 有线设备初始8000 无线设备初始256';
comment on column ${iol_schema}.mpcs_a50ubcardequip.nettype is '联网类型 c：cable有线 w：wireless无线';
comment on column ${iol_schema}.mpcs_a50ubcardequip.selfbanktype is '自助银行类型 1,自助银行厅 2，自助银行 3，自助设备厅 4，自助设备';
comment on column ${iol_schema}.mpcs_a50ubcardequip.devcatalog is '设备属性';
comment on column ${iol_schema}.mpcs_a50ubcardequip.devvendor is '设备品牌';
comment on column ${iol_schema}.mpcs_a50ubcardequip.installdate is '设备安装日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.atmparea is '银联标准地区代码';
comment on column ${iol_schema}.mpcs_a50ubcardequip.brnname is '机构名称';
comment on column ${iol_schema}.mpcs_a50ubcardequip.buydate is '购机日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.enctype is '加密方式 0-国密 1或空非国密';
comment on column ${iol_schema}.mpcs_a50ubcardequip.authcode is '申请主密钥认证码(8位装机码)';
comment on column ${iol_schema}.mpcs_a50ubcardequip.status is '';
comment on column ${iol_schema}.mpcs_a50ubcardequip.apltlrname is '申请柜员名字';
comment on column ${iol_schema}.mpcs_a50ubcardequip.applydate is '申请加钞日期';
comment on column ${iol_schema}.mpcs_a50ubcardequip.applyteller is '申请加钞柜员';
comment on column ${iol_schema}.mpcs_a50ubcardequip.atmcashboxno is 'atm机尾箱号';
comment on column ${iol_schema}.mpcs_a50ubcardequip.cashboxno is '加钞尾箱号';
comment on column ${iol_schema}.mpcs_a50ubcardequip.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a50ubcardequip.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a50ubcardequip.etl_timestamp is 'ETL处理时间戳';
