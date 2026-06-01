/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_base_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_base_info
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_base_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_base_info(
    no varchar2(20) -- 设备号
    ,ip varchar2(20) -- 设备ip地址
    ,org_no varchar2(20) -- 所属机构（组织机构/管理机构）
    ,away_flag varchar2(2) -- 离行在行标志 1：在行；2：离行
    ,dev_catalog varchar2(5) -- 设备类型
    ,dev_vendor varchar2(5) -- 设备品牌
    ,dev_type varchar2(5) -- 设备型号
    ,work_type varchar2(2) -- 经营方式 1—自营  2—联营
    ,status varchar2(2) -- （该字段禁止使用）设备状态 1—正常  2—停机
    ,dev_service varchar2(40) -- 设备维护商
    ,terminal_no varchar2(20) -- 终端号
    ,serial varchar2(40) -- 设备序列号 :厂商出厂的序列号
    ,address varchar2(120) -- 设备地址
    ,buy_date varchar2(10) -- 设备购买日期 yyyy-mm-dd
    ,install_date varchar2(10) -- 设备安装日期 yyyy-mm-dd
    ,start_date varchar2(10) -- 设备启用日期 yyyy-mm-dd
    ,stop_date varchar2(10) -- 设备停用日期 yyyy-mm-dd
    ,open_time varchar2(10) -- 每日开机时间 hh:mm:ss
    ,close_time varchar2(10) -- 每日关机时间 hh:mm:ss
    ,expire_date varchar2(10) -- 保修到期日期 yyyy-mm-dd
    ,patrol_period varchar2(20) -- 设备巡检周期
    ,area_no varchar2(10) -- 区域编号
    ,x varchar2(20) -- 横坐标（经度）
    ,y varchar2(20) -- 纵坐标（纬度）
    ,cashbox_limit varchar2(50) -- 钱箱报警金额
    ,os varchar2(5) -- 操作系统
    ,atmc_soft varchar2(50) -- atmc软件 1:wsap ;2:wsapplus ;3:zjuap;9:其他atmc
    ,anti_virus_soft varchar2(50) -- 防病毒软件
    ,sp varchar2(50) -- 厂商sp类型
    ,virtual_teller_no varchar2(12) -- 虚拟柜员号
    ,care_level varchar2(2) -- 设备关注程度 1-重点 2-中等 3-一般
    ,last_pm_date varchar2(10) -- 上次巡检日期
    ,expire_pm_date varchar2(10) -- 巡检到期日期
    ,locate_no varchar2(10) -- 地理位置
    ,note1 varchar2(30) -- 备用1:设备营运状态 1启用 2停机
    ,note2 varchar2(30) -- 备用2:有无盲道 0-无 1-有，默认0
    ,note3 varchar2(30) -- 备用3:邮政编码
    ,note4 varchar2(30) -- 备用4
    ,note5 varchar2(30) -- 备用5
    ,carrier varchar2(20) -- 运营商
    ,money_org varchar2(20) -- 加钞机构
    ,dev_status varchar2(2) -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
    ,environment varchar2(256) -- 周边环境
    ,address_code varchar2(20) -- 地点代码
    ,cash_type varchar2(2) -- 非现金标志: 1、现金；2、非现金
    ,setup_type varchar2(2) -- 安装方式:0、大堂；1、穿墙
    ,net_type varchar2(2) -- 有线无线标志:c：cable有线 w：wireless无线
    ,operate_status varchar2(2) -- （设备停机功能使用）运营状态:1： 启用 2：停机
    ,registration_status varchar2(2) -- 注册状态:0：未注册 1：注册
    ,comm_packet varchar2(20) -- 通讯每包传输大小:有线设备初始8000无线设备初始256
    ,zip_type varchar2(2) -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
    ,dek_encoded varchar2(100) -- mak密钥
    ,atmp_area varchar2(10) -- p端区域码
    ,selfbanktype varchar2(2) -- 自助银行类型
    ,arm_type number(22) -- 
    ,pref_no varchar2(4) -- 所属地区
    ,country_no varchar2(6) -- 所属区划代码
    ,postcode varchar2(6) -- 邮政编码
    ,contact varchar2(1) -- 联接方式
    ,acpt_ins_id_cd varchar2(8) -- 内卡收单机构代码
    ,invstr_ins_id_cd varchar2(8) -- 设备投资方代码
    ,maintn_ins_id_cd varchar2(8) -- 运行维护方代码
    ,term_publicize_chnl varchar2(100) -- 终端渠道宣传
    ,socket varchar2(100) -- 终端通讯方式
    ,frn_acpt_tp varchar2(2) -- 外卡功能
    ,scan_code varchar2(2) -- 扫码功能
    ,magn_read_in varchar2(2) -- 磁条卡读取功能
    ,no_card varchar2(2) -- 无卡支付功能
    ,cont_ic_in varchar2(2) -- 接触式ic卡读取功能
    ,contless_ic_in varchar2(2) -- 非接触式ic卡读取功能
    ,term_tran_fun varchar2(100) -- 终端业务功能（存款取款转账等）
    ,last_statue varchar2(1) -- 设备信息最后一次状态：“i”：新增，“u”：修改，“d”：删除
    ,is_export number(22) -- 是否已导出字段：0：未导出，1：已导出
    ,deploy_area_no varchar2(2) -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
    ,deploy_area_name varchar2(100) -- 部署区域具体名称
    ,terminal_status varchar2(2) -- 终端状态 2-注销 1-启用
    ,account_org_no varchar2(20) -- 账务机构号
    ,self_bank_no varchar2(40) -- 自助银行号，离行设备设置该字段
    ,dev_log_path varchar2(200) -- 日志路径
    ,trans_rate varchar2(20) -- 文件传输速度上限
    ,comm_cst_no varchar2(100) -- 村经济合作社客户号
    ,term_account_no varchar2(22) -- 终端账户账号
    ,management_name varchar2(60) -- 管理员名称
    ,account_type number(5,0) -- 帐户类型
    ,card_flag number(5,0) -- 卡折标志
    ,check_org varchar2(20) -- 核算机构
    ,tradingvolume number(5,0) -- 业务量目标值
    ,encryptmode varchar2(10) -- 终端数据加密模式
    ,cycle_flag number(5,0) -- 是否开通循环（crs设备）：0-未开通，1-开通
    ,region varchar2(30) -- 省
    ,city varchar2(30) -- 市
    ,manage_org_no varchar2(20) -- 管理机构号
    ,route varchar2(32) -- 清机加钞线路
    ,zjuapmodal varchar2(1) -- zjuap模式
    ,apps varchar2(200) -- 选择关闭的功能
    ,modify_time varchar2(10) -- 上次修改日期（yyyy-mm-dd）
    ,comments varchar2(12) -- 取款虚拟柜员号
    ,dac varchar2(12) -- 存款虚拟柜员号
    ,change_date varchar2(10) -- 自助设备更换日期（yyyy-mm-dd）
    ,before_dev_type varchar2(5) -- 更换前型号
    ,pick_flag varchar2(1) -- 是否支持非接
    ,pwd_flag varchar2(1) -- 是否支持国密
    ,lock_id varchar2(20) -- 电子密码锁锁具编号
    ,lock_date varchar2(10) -- 开锁日期
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
grant select on ${iol_schema}.atms_dev_base_info to ${iml_schema};
grant select on ${iol_schema}.atms_dev_base_info to ${icl_schema};
grant select on ${iol_schema}.atms_dev_base_info to ${idl_schema};
grant select on ${iol_schema}.atms_dev_base_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_base_info is '';
comment on column ${iol_schema}.atms_dev_base_info.no is '设备号';
comment on column ${iol_schema}.atms_dev_base_info.ip is '设备ip地址';
comment on column ${iol_schema}.atms_dev_base_info.org_no is '所属机构（组织机构/管理机构）';
comment on column ${iol_schema}.atms_dev_base_info.away_flag is '离行在行标志 1：在行；2：离行';
comment on column ${iol_schema}.atms_dev_base_info.dev_catalog is '设备类型';
comment on column ${iol_schema}.atms_dev_base_info.dev_vendor is '设备品牌';
comment on column ${iol_schema}.atms_dev_base_info.dev_type is '设备型号';
comment on column ${iol_schema}.atms_dev_base_info.work_type is '经营方式 1—自营  2—联营';
comment on column ${iol_schema}.atms_dev_base_info.status is '（该字段禁止使用）设备状态 1—正常  2—停机';
comment on column ${iol_schema}.atms_dev_base_info.dev_service is '设备维护商';
comment on column ${iol_schema}.atms_dev_base_info.terminal_no is '终端号';
comment on column ${iol_schema}.atms_dev_base_info.serial is '设备序列号 :厂商出厂的序列号';
comment on column ${iol_schema}.atms_dev_base_info.address is '设备地址';
comment on column ${iol_schema}.atms_dev_base_info.buy_date is '设备购买日期 yyyy-mm-dd';
comment on column ${iol_schema}.atms_dev_base_info.install_date is '设备安装日期 yyyy-mm-dd';
comment on column ${iol_schema}.atms_dev_base_info.start_date is '设备启用日期 yyyy-mm-dd';
comment on column ${iol_schema}.atms_dev_base_info.stop_date is '设备停用日期 yyyy-mm-dd';
comment on column ${iol_schema}.atms_dev_base_info.open_time is '每日开机时间 hh:mm:ss';
comment on column ${iol_schema}.atms_dev_base_info.close_time is '每日关机时间 hh:mm:ss';
comment on column ${iol_schema}.atms_dev_base_info.expire_date is '保修到期日期 yyyy-mm-dd';
comment on column ${iol_schema}.atms_dev_base_info.patrol_period is '设备巡检周期';
comment on column ${iol_schema}.atms_dev_base_info.area_no is '区域编号';
comment on column ${iol_schema}.atms_dev_base_info.x is '横坐标（经度）';
comment on column ${iol_schema}.atms_dev_base_info.y is '纵坐标（纬度）';
comment on column ${iol_schema}.atms_dev_base_info.cashbox_limit is '钱箱报警金额';
comment on column ${iol_schema}.atms_dev_base_info.os is '操作系统';
comment on column ${iol_schema}.atms_dev_base_info.atmc_soft is 'atmc软件 1:wsap ;2:wsapplus ;3:zjuap;9:其他atmc';
comment on column ${iol_schema}.atms_dev_base_info.anti_virus_soft is '防病毒软件';
comment on column ${iol_schema}.atms_dev_base_info.sp is '厂商sp类型';
comment on column ${iol_schema}.atms_dev_base_info.virtual_teller_no is '虚拟柜员号';
comment on column ${iol_schema}.atms_dev_base_info.care_level is '设备关注程度 1-重点 2-中等 3-一般';
comment on column ${iol_schema}.atms_dev_base_info.last_pm_date is '上次巡检日期';
comment on column ${iol_schema}.atms_dev_base_info.expire_pm_date is '巡检到期日期';
comment on column ${iol_schema}.atms_dev_base_info.locate_no is '地理位置';
comment on column ${iol_schema}.atms_dev_base_info.note1 is '备用1:设备营运状态 1启用 2停机';
comment on column ${iol_schema}.atms_dev_base_info.note2 is '备用2:有无盲道 0-无 1-有，默认0';
comment on column ${iol_schema}.atms_dev_base_info.note3 is '备用3:邮政编码';
comment on column ${iol_schema}.atms_dev_base_info.note4 is '备用4';
comment on column ${iol_schema}.atms_dev_base_info.note5 is '备用5';
comment on column ${iol_schema}.atms_dev_base_info.carrier is '运营商';
comment on column ${iol_schema}.atms_dev_base_info.money_org is '加钞机构';
comment on column ${iol_schema}.atms_dev_base_info.dev_status is '设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销';
comment on column ${iol_schema}.atms_dev_base_info.environment is '周边环境';
comment on column ${iol_schema}.atms_dev_base_info.address_code is '地点代码';
comment on column ${iol_schema}.atms_dev_base_info.cash_type is '非现金标志: 1、现金；2、非现金';
comment on column ${iol_schema}.atms_dev_base_info.setup_type is '安装方式:0、大堂；1、穿墙';
comment on column ${iol_schema}.atms_dev_base_info.net_type is '有线无线标志:c：cable有线 w：wireless无线';
comment on column ${iol_schema}.atms_dev_base_info.operate_status is '（设备停机功能使用）运营状态:1： 启用 2：停机';
comment on column ${iol_schema}.atms_dev_base_info.registration_status is '注册状态:0：未注册 1：注册';
comment on column ${iol_schema}.atms_dev_base_info.comm_packet is '通讯每包传输大小:有线设备初始8000无线设备初始256';
comment on column ${iol_schema}.atms_dev_base_info.zip_type is '通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3';
comment on column ${iol_schema}.atms_dev_base_info.dek_encoded is 'mak密钥';
comment on column ${iol_schema}.atms_dev_base_info.atmp_area is 'p端区域码';
comment on column ${iol_schema}.atms_dev_base_info.selfbanktype is '自助银行类型';
comment on column ${iol_schema}.atms_dev_base_info.arm_type is '';
comment on column ${iol_schema}.atms_dev_base_info.pref_no is '所属地区';
comment on column ${iol_schema}.atms_dev_base_info.country_no is '所属区划代码';
comment on column ${iol_schema}.atms_dev_base_info.postcode is '邮政编码';
comment on column ${iol_schema}.atms_dev_base_info.contact is '联接方式';
comment on column ${iol_schema}.atms_dev_base_info.acpt_ins_id_cd is '内卡收单机构代码';
comment on column ${iol_schema}.atms_dev_base_info.invstr_ins_id_cd is '设备投资方代码';
comment on column ${iol_schema}.atms_dev_base_info.maintn_ins_id_cd is '运行维护方代码';
comment on column ${iol_schema}.atms_dev_base_info.term_publicize_chnl is '终端渠道宣传';
comment on column ${iol_schema}.atms_dev_base_info.socket is '终端通讯方式';
comment on column ${iol_schema}.atms_dev_base_info.frn_acpt_tp is '外卡功能';
comment on column ${iol_schema}.atms_dev_base_info.scan_code is '扫码功能';
comment on column ${iol_schema}.atms_dev_base_info.magn_read_in is '磁条卡读取功能';
comment on column ${iol_schema}.atms_dev_base_info.no_card is '无卡支付功能';
comment on column ${iol_schema}.atms_dev_base_info.cont_ic_in is '接触式ic卡读取功能';
comment on column ${iol_schema}.atms_dev_base_info.contless_ic_in is '非接触式ic卡读取功能';
comment on column ${iol_schema}.atms_dev_base_info.term_tran_fun is '终端业务功能（存款取款转账等）';
comment on column ${iol_schema}.atms_dev_base_info.last_statue is '设备信息最后一次状态：“i”：新增，“u”：修改，“d”：删除';
comment on column ${iol_schema}.atms_dev_base_info.is_export is '是否已导出字段：0：未导出，1：已导出';
comment on column ${iol_schema}.atms_dev_base_info.deploy_area_no is '部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域';
comment on column ${iol_schema}.atms_dev_base_info.deploy_area_name is '部署区域具体名称';
comment on column ${iol_schema}.atms_dev_base_info.terminal_status is '终端状态 2-注销 1-启用';
comment on column ${iol_schema}.atms_dev_base_info.account_org_no is '账务机构号';
comment on column ${iol_schema}.atms_dev_base_info.self_bank_no is '自助银行号，离行设备设置该字段';
comment on column ${iol_schema}.atms_dev_base_info.dev_log_path is '日志路径';
comment on column ${iol_schema}.atms_dev_base_info.trans_rate is '文件传输速度上限';
comment on column ${iol_schema}.atms_dev_base_info.comm_cst_no is '村经济合作社客户号';
comment on column ${iol_schema}.atms_dev_base_info.term_account_no is '终端账户账号';
comment on column ${iol_schema}.atms_dev_base_info.management_name is '管理员名称';
comment on column ${iol_schema}.atms_dev_base_info.account_type is '帐户类型';
comment on column ${iol_schema}.atms_dev_base_info.card_flag is '卡折标志';
comment on column ${iol_schema}.atms_dev_base_info.check_org is '核算机构';
comment on column ${iol_schema}.atms_dev_base_info.tradingvolume is '业务量目标值';
comment on column ${iol_schema}.atms_dev_base_info.encryptmode is '终端数据加密模式';
comment on column ${iol_schema}.atms_dev_base_info.cycle_flag is '是否开通循环（crs设备）：0-未开通，1-开通';
comment on column ${iol_schema}.atms_dev_base_info.region is '省';
comment on column ${iol_schema}.atms_dev_base_info.city is '市';
comment on column ${iol_schema}.atms_dev_base_info.manage_org_no is '管理机构号';
comment on column ${iol_schema}.atms_dev_base_info.route is '清机加钞线路';
comment on column ${iol_schema}.atms_dev_base_info.zjuapmodal is 'zjuap模式';
comment on column ${iol_schema}.atms_dev_base_info.apps is '选择关闭的功能';
comment on column ${iol_schema}.atms_dev_base_info.modify_time is '上次修改日期（yyyy-mm-dd）';
comment on column ${iol_schema}.atms_dev_base_info.comments is '取款虚拟柜员号';
comment on column ${iol_schema}.atms_dev_base_info.dac is '存款虚拟柜员号';
comment on column ${iol_schema}.atms_dev_base_info.change_date is '自助设备更换日期（yyyy-mm-dd）';
comment on column ${iol_schema}.atms_dev_base_info.before_dev_type is '更换前型号';
comment on column ${iol_schema}.atms_dev_base_info.pick_flag is '是否支持非接';
comment on column ${iol_schema}.atms_dev_base_info.pwd_flag is '是否支持国密';
comment on column ${iol_schema}.atms_dev_base_info.lock_id is '电子密码锁锁具编号';
comment on column ${iol_schema}.atms_dev_base_info.lock_date is '开锁日期';
comment on column ${iol_schema}.atms_dev_base_info.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_base_info.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_base_info.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_base_info.etl_timestamp is 'ETL处理时间戳';
