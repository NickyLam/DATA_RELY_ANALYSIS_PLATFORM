/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a86mpanmapinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a86mpanmapinfo
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a86mpanmapinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a86mpanmapinfo(
    transtime varchar2(21) -- 操作时间
    ,custno varchar2(30) -- 客户号
    ,paysys varchar2(2) -- 0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他
    ,seid varchar2(96) -- 用户移动设备中安全芯片所对应的标识符
    ,span varchar2(30) -- 用户用于移动设备加申请的标准卡主账号
    ,spanid varchar2(96) -- 用户标准卡主账号对应的标识符
    ,mpan varchar2(30) -- 用户成功加载的移动设备卡主账号
    ,mpanid varchar2(96) -- 用户移动设备卡主账号对应的标识符
    ,mstpan varchar2(30) -- 用户成功加载的移动mst设备卡主账号
    ,mstpanid varchar2(96) -- 用户移动mst设备卡主账号对应的标识符
    ,mappingstatus varchar2(6) -- 映射关系状态 00初始 01可用 02锁定 03注销
    ,mpanpersoresult varchar2(6) -- mpan应用个人化执行结果
    ,custname varchar2(60) -- 持卡人姓名
    ,phone varchar2(30) -- 预留手机号码
    ,opechannelid varchar2(15) -- 操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商
    ,quota varchar2(30) -- 初始免密限额
    ,setype varchar2(15) -- 前4位 1011 apple产品  0011全手机模式
    ,seissuer varchar2(30) -- 前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派
    ,termconditionid varchar2(96) -- 协议和条款对应的id
    ,termconditionaccepteddate varchar2(48) -- 用户接受协议和条款的日期和具体时间
    ,cardartid varchar2(96) -- 卡面配置方案id
    ,invaluedate varchar2(12) -- 有效期
    ,storeidentifier varchar2(195) -- 银行返回的bank app应用商店标识符
    ,applicationid varchar2(195) -- 该卡对应的application id列表
    ,otpresolutionid varchar2(60) -- otp方法所对应的标识号
    ,remark1 varchar2(75) -- 
    ,remark2 varchar2(75) -- 
    ,remark3 varchar2(300) -- 
    ,remark4 varchar2(300) -- 
    ,remark5 varchar2(300) -- 
    ,remark6 varchar2(300) -- 
    ,remark7 varchar2(768) -- 
    ,remark8 varchar2(768) -- 
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
grant select on ${iol_schema}.mpcs_a86mpanmapinfo to ${iml_schema};
grant select on ${iol_schema}.mpcs_a86mpanmapinfo to ${icl_schema};
grant select on ${iol_schema}.mpcs_a86mpanmapinfo to ${idl_schema};
grant select on ${iol_schema}.mpcs_a86mpanmapinfo to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a86mpanmapinfo is '设备卡映射表';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.transtime is '操作时间';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.custno is '客户号';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.paysys is '0-apple 1-华为 2-小米 3-三星 4-中兴 5-联想 6-咕咚 7-捷德 8-oppo 9-金立 a-乐视 b-美图 c-魅族 d-锤子手机 e-vivo手机 f-奇酷(360) g-酷派 z-其他';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.seid is '用户移动设备中安全芯片所对应的标识符';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.span is '用户用于移动设备加申请的标准卡主账号';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.spanid is '用户标准卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mpan is '用户成功加载的移动设备卡主账号';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mpanid is '用户移动设备卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mstpan is '用户成功加载的移动mst设备卡主账号';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mstpanid is '用户移动mst设备卡主账号对应的标识符';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mappingstatus is '映射关系状态 00初始 01可用 02锁定 03注销';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.mpanpersoresult is 'mpan应用个人化执行结果';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.custname is '持卡人姓名';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.phone is '预留手机号码';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.opechannelid is '操作发起渠道00发卡行 01载体发行方02银联03第三方服务提供商';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.quota is '初始免密限额';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.setype is '前4位 1011 apple产品  0011全手机模式';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.seissuer is '前3位010, 后面5位   00000=apple 00001=华为 00010=小米 00011=三星 00100=中兴 00101=联想 00110=咕咚 00111=捷德 01000=oppo 01001=金立 01010=乐视 01011=美图 01100=魅族 01101=锤子手机 01110=vivo手机 01111=奇酷(360) 10000=酷派';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.termconditionid is '协议和条款对应的id';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.termconditionaccepteddate is '用户接受协议和条款的日期和具体时间';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.cardartid is '卡面配置方案id';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.invaluedate is '有效期';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.storeidentifier is '银行返回的bank app应用商店标识符';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.applicationid is '该卡对应的application id列表';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.otpresolutionid is 'otp方法所对应的标识号';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark1 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark2 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark3 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark4 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark5 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark6 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark7 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.remark8 is '';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a86mpanmapinfo.etl_timestamp is 'ETL处理时间戳';
