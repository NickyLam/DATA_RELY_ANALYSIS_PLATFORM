/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_base_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.atms_dev_base_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_base_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_base_info_op purge;
drop table ${iol_schema}.atms_dev_base_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_base_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_base_info where 0=1;

create table ${iol_schema}.atms_dev_base_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_base_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_base_info_cl(
            no -- 设备号
            ,ip -- 设备IP地址
            ,org_no -- 所属机构（组织机构/管理机构）
            ,away_flag -- 离行在行标志 1：在行；2：离行
            ,dev_catalog -- 设备类型
            ,dev_vendor -- 设备品牌
            ,dev_type -- 设备型号
            ,work_type -- 经营方式 1—自营  2—联营
            ,status -- （该字段禁止使用）设备状态 1—正常  2—停机
            ,dev_service -- 设备维护商
            ,terminal_no -- 终端号
            ,serial -- 设备序列号 :厂商出厂的序列号
            ,address -- 设备地址
            ,buy_date -- 设备购买日期 yyyy-mm-dd
            ,install_date -- 设备安装日期 yyyy-mm-dd
            ,start_date -- 设备启用日期 yyyy-mm-dd
            ,stop_date -- 设备停用日期 yyyy-mm-dd
            ,open_time -- 每日开机时间 HH:mm:ss
            ,close_time -- 每日关机时间 HH:mm:ss
            ,expire_date -- 保修到期日期 yyyy-mm-dd
            ,patrol_period -- 设备巡检周期
            ,area_no -- 区域编号
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,cashbox_limit -- 钱箱报警金额
            ,os -- 操作系统
            ,atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
            ,anti_virus_soft -- 防病毒软件
            ,sp -- 厂商sp类型
            ,virtual_teller_no -- 虚拟柜员号
            ,care_level -- 设备关注程度 1-重点 2-中等 3-一般
            ,last_pm_date -- 上次巡检日期
            ,expire_pm_date -- 巡检到期日期
            ,locate_no -- 地理位置
            ,note1 -- 备用1:设备营运状态 1启用 2停机
            ,note2 -- 备用2:有无盲道 0-无 1-有，默认0
            ,note3 -- 备用3:邮政编码
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,carrier -- 运营商
            ,money_org -- 加钞机构
            ,dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
            ,environment -- 周边环境
            ,address_code -- 地点代码
            ,cash_type -- 非现金标志: 1、现金；2、非现金
            ,setup_type -- 安装方式:0、大堂；1、穿墙
            ,net_type -- 有线无线标志:C：cable有线 W：wireless无线
            ,operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
            ,registration_status -- 注册状态:0：未注册 1：注册
            ,comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
            ,zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
            ,dek_encoded -- MAK密钥
            ,atmp_area -- p端区域码
            ,selfbanktype -- 自助银行类型
            ,arm_type -- 
            ,pref_no -- 所属地区
            ,country_no -- 所属区划代码
            ,postcode -- 邮政编码
            ,contact -- 联接方式
            ,acpt_ins_id_cd -- 内卡收单机构代码
            ,invstr_ins_id_cd -- 设备投资方代码
            ,maintn_ins_id_cd -- 运行维护方代码
            ,term_publicize_chnl -- 终端渠道宣传
            ,socket -- 终端通讯方式
            ,frn_acpt_tp -- 外卡功能
            ,scan_code -- 扫码功能
            ,magn_read_in -- 磁条卡读取功能
            ,no_card -- 无卡支付功能
            ,cont_ic_in -- 接触式IC卡读取功能
            ,contless_ic_in -- 非接触式IC卡读取功能
            ,term_tran_fun -- 终端业务功能（存款取款转账等）
            ,last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
            ,is_export -- 是否已导出字段：0：未导出，1：已导出
            ,deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
            ,deploy_area_name -- 部署区域具体名称
            ,terminal_status -- 终端状态 2-注销 1-启用
            ,account_org_no -- 账务机构号
            ,self_bank_no -- 自助银行号，离行设备设置该字段
            ,dev_log_path -- 日志路径
            ,trans_rate -- 文件传输速度上限
            ,comm_cst_no -- 村经济合作社客户号
            ,term_account_no -- 终端账户账号
            ,management_name -- 管理员名称
            ,account_type -- 帐户类型
            ,card_flag -- 卡折标志
            ,check_org -- 核算机构
            ,tradingvolume -- 业务量目标值
            ,encryptmode -- 终端数据加密模式
            ,cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
            ,region -- 省
            ,city -- 市
            ,manage_org_no -- 管理机构号
            ,route -- 清机加钞线路
            ,zjuapmodal -- zjuap模式
            ,apps -- 选择关闭的功能
            ,modify_time -- 上次修改日期（YYYY-MM-DD）
            ,comments -- 取款虚拟柜员号
            ,dac -- 存款虚拟柜员号
            ,change_date -- 自助设备更换日期（YYYY-MM-DD）
            ,before_dev_type -- 更换前型号
            ,pick_flag -- 是否支持非接
            ,pwd_flag -- 是否支持国密
            ,lock_id -- 电子密码锁锁具编号
            ,lock_date -- 开锁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_base_info_op(
            no -- 设备号
            ,ip -- 设备IP地址
            ,org_no -- 所属机构（组织机构/管理机构）
            ,away_flag -- 离行在行标志 1：在行；2：离行
            ,dev_catalog -- 设备类型
            ,dev_vendor -- 设备品牌
            ,dev_type -- 设备型号
            ,work_type -- 经营方式 1—自营  2—联营
            ,status -- （该字段禁止使用）设备状态 1—正常  2—停机
            ,dev_service -- 设备维护商
            ,terminal_no -- 终端号
            ,serial -- 设备序列号 :厂商出厂的序列号
            ,address -- 设备地址
            ,buy_date -- 设备购买日期 yyyy-mm-dd
            ,install_date -- 设备安装日期 yyyy-mm-dd
            ,start_date -- 设备启用日期 yyyy-mm-dd
            ,stop_date -- 设备停用日期 yyyy-mm-dd
            ,open_time -- 每日开机时间 HH:mm:ss
            ,close_time -- 每日关机时间 HH:mm:ss
            ,expire_date -- 保修到期日期 yyyy-mm-dd
            ,patrol_period -- 设备巡检周期
            ,area_no -- 区域编号
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,cashbox_limit -- 钱箱报警金额
            ,os -- 操作系统
            ,atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
            ,anti_virus_soft -- 防病毒软件
            ,sp -- 厂商sp类型
            ,virtual_teller_no -- 虚拟柜员号
            ,care_level -- 设备关注程度 1-重点 2-中等 3-一般
            ,last_pm_date -- 上次巡检日期
            ,expire_pm_date -- 巡检到期日期
            ,locate_no -- 地理位置
            ,note1 -- 备用1:设备营运状态 1启用 2停机
            ,note2 -- 备用2:有无盲道 0-无 1-有，默认0
            ,note3 -- 备用3:邮政编码
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,carrier -- 运营商
            ,money_org -- 加钞机构
            ,dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
            ,environment -- 周边环境
            ,address_code -- 地点代码
            ,cash_type -- 非现金标志: 1、现金；2、非现金
            ,setup_type -- 安装方式:0、大堂；1、穿墙
            ,net_type -- 有线无线标志:C：cable有线 W：wireless无线
            ,operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
            ,registration_status -- 注册状态:0：未注册 1：注册
            ,comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
            ,zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
            ,dek_encoded -- MAK密钥
            ,atmp_area -- p端区域码
            ,selfbanktype -- 自助银行类型
            ,arm_type -- 
            ,pref_no -- 所属地区
            ,country_no -- 所属区划代码
            ,postcode -- 邮政编码
            ,contact -- 联接方式
            ,acpt_ins_id_cd -- 内卡收单机构代码
            ,invstr_ins_id_cd -- 设备投资方代码
            ,maintn_ins_id_cd -- 运行维护方代码
            ,term_publicize_chnl -- 终端渠道宣传
            ,socket -- 终端通讯方式
            ,frn_acpt_tp -- 外卡功能
            ,scan_code -- 扫码功能
            ,magn_read_in -- 磁条卡读取功能
            ,no_card -- 无卡支付功能
            ,cont_ic_in -- 接触式IC卡读取功能
            ,contless_ic_in -- 非接触式IC卡读取功能
            ,term_tran_fun -- 终端业务功能（存款取款转账等）
            ,last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
            ,is_export -- 是否已导出字段：0：未导出，1：已导出
            ,deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
            ,deploy_area_name -- 部署区域具体名称
            ,terminal_status -- 终端状态 2-注销 1-启用
            ,account_org_no -- 账务机构号
            ,self_bank_no -- 自助银行号，离行设备设置该字段
            ,dev_log_path -- 日志路径
            ,trans_rate -- 文件传输速度上限
            ,comm_cst_no -- 村经济合作社客户号
            ,term_account_no -- 终端账户账号
            ,management_name -- 管理员名称
            ,account_type -- 帐户类型
            ,card_flag -- 卡折标志
            ,check_org -- 核算机构
            ,tradingvolume -- 业务量目标值
            ,encryptmode -- 终端数据加密模式
            ,cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
            ,region -- 省
            ,city -- 市
            ,manage_org_no -- 管理机构号
            ,route -- 清机加钞线路
            ,zjuapmodal -- zjuap模式
            ,apps -- 选择关闭的功能
            ,modify_time -- 上次修改日期（YYYY-MM-DD）
            ,comments -- 取款虚拟柜员号
            ,dac -- 存款虚拟柜员号
            ,change_date -- 自助设备更换日期（YYYY-MM-DD）
            ,before_dev_type -- 更换前型号
            ,pick_flag -- 是否支持非接
            ,pwd_flag -- 是否支持国密
            ,lock_id -- 电子密码锁锁具编号
            ,lock_date -- 开锁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.no, o.no) as no -- 设备号
    ,nvl(n.ip, o.ip) as ip -- 设备IP地址
    ,nvl(n.org_no, o.org_no) as org_no -- 所属机构（组织机构/管理机构）
    ,nvl(n.away_flag, o.away_flag) as away_flag -- 离行在行标志 1：在行；2：离行
    ,nvl(n.dev_catalog, o.dev_catalog) as dev_catalog -- 设备类型
    ,nvl(n.dev_vendor, o.dev_vendor) as dev_vendor -- 设备品牌
    ,nvl(n.dev_type, o.dev_type) as dev_type -- 设备型号
    ,nvl(n.work_type, o.work_type) as work_type -- 经营方式 1—自营  2—联营
    ,nvl(n.status, o.status) as status -- （该字段禁止使用）设备状态 1—正常  2—停机
    ,nvl(n.dev_service, o.dev_service) as dev_service -- 设备维护商
    ,nvl(n.terminal_no, o.terminal_no) as terminal_no -- 终端号
    ,nvl(n.serial, o.serial) as serial -- 设备序列号 :厂商出厂的序列号
    ,nvl(n.address, o.address) as address -- 设备地址
    ,nvl(n.buy_date, o.buy_date) as buy_date -- 设备购买日期 yyyy-mm-dd
    ,nvl(n.install_date, o.install_date) as install_date -- 设备安装日期 yyyy-mm-dd
    ,nvl(n.start_date, o.start_date) as start_date -- 设备启用日期 yyyy-mm-dd
    ,nvl(n.stop_date, o.stop_date) as stop_date -- 设备停用日期 yyyy-mm-dd
    ,nvl(n.open_time, o.open_time) as open_time -- 每日开机时间 HH:mm:ss
    ,nvl(n.close_time, o.close_time) as close_time -- 每日关机时间 HH:mm:ss
    ,nvl(n.expire_date, o.expire_date) as expire_date -- 保修到期日期 yyyy-mm-dd
    ,nvl(n.patrol_period, o.patrol_period) as patrol_period -- 设备巡检周期
    ,nvl(n.area_no, o.area_no) as area_no -- 区域编号
    ,nvl(n.x, o.x) as x -- 横坐标（经度）
    ,nvl(n.y, o.y) as y -- 纵坐标（纬度）
    ,nvl(n.cashbox_limit, o.cashbox_limit) as cashbox_limit -- 钱箱报警金额
    ,nvl(n.os, o.os) as os -- 操作系统
    ,nvl(n.atmc_soft, o.atmc_soft) as atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
    ,nvl(n.anti_virus_soft, o.anti_virus_soft) as anti_virus_soft -- 防病毒软件
    ,nvl(n.sp, o.sp) as sp -- 厂商sp类型
    ,nvl(n.virtual_teller_no, o.virtual_teller_no) as virtual_teller_no -- 虚拟柜员号
    ,nvl(n.care_level, o.care_level) as care_level -- 设备关注程度 1-重点 2-中等 3-一般
    ,nvl(n.last_pm_date, o.last_pm_date) as last_pm_date -- 上次巡检日期
    ,nvl(n.expire_pm_date, o.expire_pm_date) as expire_pm_date -- 巡检到期日期
    ,nvl(n.locate_no, o.locate_no) as locate_no -- 地理位置
    ,nvl(n.note1, o.note1) as note1 -- 备用1:设备营运状态 1启用 2停机
    ,nvl(n.note2, o.note2) as note2 -- 备用2:有无盲道 0-无 1-有，默认0
    ,nvl(n.note3, o.note3) as note3 -- 备用3:邮政编码
    ,nvl(n.note4, o.note4) as note4 -- 备用4
    ,nvl(n.note5, o.note5) as note5 -- 备用5
    ,nvl(n.carrier, o.carrier) as carrier -- 运营商
    ,nvl(n.money_org, o.money_org) as money_org -- 加钞机构
    ,nvl(n.dev_status, o.dev_status) as dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
    ,nvl(n.environment, o.environment) as environment -- 周边环境
    ,nvl(n.address_code, o.address_code) as address_code -- 地点代码
    ,nvl(n.cash_type, o.cash_type) as cash_type -- 非现金标志: 1、现金；2、非现金
    ,nvl(n.setup_type, o.setup_type) as setup_type -- 安装方式:0、大堂；1、穿墙
    ,nvl(n.net_type, o.net_type) as net_type -- 有线无线标志:C：cable有线 W：wireless无线
    ,nvl(n.operate_status, o.operate_status) as operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
    ,nvl(n.registration_status, o.registration_status) as registration_status -- 注册状态:0：未注册 1：注册
    ,nvl(n.comm_packet, o.comm_packet) as comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
    ,nvl(n.zip_type, o.zip_type) as zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
    ,nvl(n.dek_encoded, o.dek_encoded) as dek_encoded -- MAK密钥
    ,nvl(n.atmp_area, o.atmp_area) as atmp_area -- p端区域码
    ,nvl(n.selfbanktype, o.selfbanktype) as selfbanktype -- 自助银行类型
    ,nvl(n.arm_type, o.arm_type) as arm_type -- 
    ,nvl(n.pref_no, o.pref_no) as pref_no -- 所属地区
    ,nvl(n.country_no, o.country_no) as country_no -- 所属区划代码
    ,nvl(n.postcode, o.postcode) as postcode -- 邮政编码
    ,nvl(n.contact, o.contact) as contact -- 联接方式
    ,nvl(n.acpt_ins_id_cd, o.acpt_ins_id_cd) as acpt_ins_id_cd -- 内卡收单机构代码
    ,nvl(n.invstr_ins_id_cd, o.invstr_ins_id_cd) as invstr_ins_id_cd -- 设备投资方代码
    ,nvl(n.maintn_ins_id_cd, o.maintn_ins_id_cd) as maintn_ins_id_cd -- 运行维护方代码
    ,nvl(n.term_publicize_chnl, o.term_publicize_chnl) as term_publicize_chnl -- 终端渠道宣传
    ,nvl(n.socket, o.socket) as socket -- 终端通讯方式
    ,nvl(n.frn_acpt_tp, o.frn_acpt_tp) as frn_acpt_tp -- 外卡功能
    ,nvl(n.scan_code, o.scan_code) as scan_code -- 扫码功能
    ,nvl(n.magn_read_in, o.magn_read_in) as magn_read_in -- 磁条卡读取功能
    ,nvl(n.no_card, o.no_card) as no_card -- 无卡支付功能
    ,nvl(n.cont_ic_in, o.cont_ic_in) as cont_ic_in -- 接触式IC卡读取功能
    ,nvl(n.contless_ic_in, o.contless_ic_in) as contless_ic_in -- 非接触式IC卡读取功能
    ,nvl(n.term_tran_fun, o.term_tran_fun) as term_tran_fun -- 终端业务功能（存款取款转账等）
    ,nvl(n.last_statue, o.last_statue) as last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
    ,nvl(n.is_export, o.is_export) as is_export -- 是否已导出字段：0：未导出，1：已导出
    ,nvl(n.deploy_area_no, o.deploy_area_no) as deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
    ,nvl(n.deploy_area_name, o.deploy_area_name) as deploy_area_name -- 部署区域具体名称
    ,nvl(n.terminal_status, o.terminal_status) as terminal_status -- 终端状态 2-注销 1-启用
    ,nvl(n.account_org_no, o.account_org_no) as account_org_no -- 账务机构号
    ,nvl(n.self_bank_no, o.self_bank_no) as self_bank_no -- 自助银行号，离行设备设置该字段
    ,nvl(n.dev_log_path, o.dev_log_path) as dev_log_path -- 日志路径
    ,nvl(n.trans_rate, o.trans_rate) as trans_rate -- 文件传输速度上限
    ,nvl(n.comm_cst_no, o.comm_cst_no) as comm_cst_no -- 村经济合作社客户号
    ,nvl(n.term_account_no, o.term_account_no) as term_account_no -- 终端账户账号
    ,nvl(n.management_name, o.management_name) as management_name -- 管理员名称
    ,nvl(n.account_type, o.account_type) as account_type -- 帐户类型
    ,nvl(n.card_flag, o.card_flag) as card_flag -- 卡折标志
    ,nvl(n.check_org, o.check_org) as check_org -- 核算机构
    ,nvl(n.tradingvolume, o.tradingvolume) as tradingvolume -- 业务量目标值
    ,nvl(n.encryptmode, o.encryptmode) as encryptmode -- 终端数据加密模式
    ,nvl(n.cycle_flag, o.cycle_flag) as cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
    ,nvl(n.region, o.region) as region -- 省
    ,nvl(n.city, o.city) as city -- 市
    ,nvl(n.manage_org_no, o.manage_org_no) as manage_org_no -- 管理机构号
    ,nvl(n.route, o.route) as route -- 清机加钞线路
    ,nvl(n.zjuapmodal, o.zjuapmodal) as zjuapmodal -- zjuap模式
    ,nvl(n.apps, o.apps) as apps -- 选择关闭的功能
    ,nvl(n.modify_time, o.modify_time) as modify_time -- 上次修改日期（YYYY-MM-DD）
    ,nvl(n.comments, o.comments) as comments -- 取款虚拟柜员号
    ,nvl(n.dac, o.dac) as dac -- 存款虚拟柜员号
    ,nvl(n.change_date, o.change_date) as change_date -- 自助设备更换日期（YYYY-MM-DD）
    ,nvl(n.before_dev_type, o.before_dev_type) as before_dev_type -- 更换前型号
    ,nvl(n.pick_flag, o.pick_flag) as pick_flag -- 是否支持非接
    ,nvl(n.pwd_flag, o.pwd_flag) as pwd_flag -- 是否支持国密
    ,nvl(n.lock_id, o.lock_id) as lock_id -- 电子密码锁锁具编号
    ,nvl(n.lock_date, o.lock_date) as lock_date -- 开锁日期
    ,case when
            n.no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_dev_base_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_base_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.no = n.no
where (
        o.no is null
    )
    or (
        n.no is null
    )
    or (
        o.ip <> n.ip
        or o.org_no <> n.org_no
        or o.away_flag <> n.away_flag
        or o.dev_catalog <> n.dev_catalog
        or o.dev_vendor <> n.dev_vendor
        or o.dev_type <> n.dev_type
        or o.work_type <> n.work_type
        or o.status <> n.status
        or o.dev_service <> n.dev_service
        or o.terminal_no <> n.terminal_no
        or o.serial <> n.serial
        or o.address <> n.address
        or o.buy_date <> n.buy_date
        or o.install_date <> n.install_date
        or o.start_date <> n.start_date
        or o.stop_date <> n.stop_date
        or o.open_time <> n.open_time
        or o.close_time <> n.close_time
        or o.expire_date <> n.expire_date
        or o.patrol_period <> n.patrol_period
        or o.area_no <> n.area_no
        or o.x <> n.x
        or o.y <> n.y
        or o.cashbox_limit <> n.cashbox_limit
        or o.os <> n.os
        or o.atmc_soft <> n.atmc_soft
        or o.anti_virus_soft <> n.anti_virus_soft
        or o.sp <> n.sp
        or o.virtual_teller_no <> n.virtual_teller_no
        or o.care_level <> n.care_level
        or o.last_pm_date <> n.last_pm_date
        or o.expire_pm_date <> n.expire_pm_date
        or o.locate_no <> n.locate_no
        or o.note1 <> n.note1
        or o.note2 <> n.note2
        or o.note3 <> n.note3
        or o.note4 <> n.note4
        or o.note5 <> n.note5
        or o.carrier <> n.carrier
        or o.money_org <> n.money_org
        or o.dev_status <> n.dev_status
        or o.environment <> n.environment
        or o.address_code <> n.address_code
        or o.cash_type <> n.cash_type
        or o.setup_type <> n.setup_type
        or o.net_type <> n.net_type
        or o.operate_status <> n.operate_status
        or o.registration_status <> n.registration_status
        or o.comm_packet <> n.comm_packet
        or o.zip_type <> n.zip_type
        or o.dek_encoded <> n.dek_encoded
        or o.atmp_area <> n.atmp_area
        or o.selfbanktype <> n.selfbanktype
        or o.arm_type <> n.arm_type
        or o.pref_no <> n.pref_no
        or o.country_no <> n.country_no
        or o.postcode <> n.postcode
        or o.contact <> n.contact
        or o.acpt_ins_id_cd <> n.acpt_ins_id_cd
        or o.invstr_ins_id_cd <> n.invstr_ins_id_cd
        or o.maintn_ins_id_cd <> n.maintn_ins_id_cd
        or o.term_publicize_chnl <> n.term_publicize_chnl
        or o.socket <> n.socket
        or o.frn_acpt_tp <> n.frn_acpt_tp
        or o.scan_code <> n.scan_code
        or o.magn_read_in <> n.magn_read_in
        or o.no_card <> n.no_card
        or o.cont_ic_in <> n.cont_ic_in
        or o.contless_ic_in <> n.contless_ic_in
        or o.term_tran_fun <> n.term_tran_fun
        or o.last_statue <> n.last_statue
        or o.is_export <> n.is_export
        or o.deploy_area_no <> n.deploy_area_no
        or o.deploy_area_name <> n.deploy_area_name
        or o.terminal_status <> n.terminal_status
        or o.account_org_no <> n.account_org_no
        or o.self_bank_no <> n.self_bank_no
        or o.dev_log_path <> n.dev_log_path
        or o.trans_rate <> n.trans_rate
        or o.comm_cst_no <> n.comm_cst_no
        or o.term_account_no <> n.term_account_no
        or o.management_name <> n.management_name
        or o.account_type <> n.account_type
        or o.card_flag <> n.card_flag
        or o.check_org <> n.check_org
        or o.tradingvolume <> n.tradingvolume
        or o.encryptmode <> n.encryptmode
        or o.cycle_flag <> n.cycle_flag
        or o.region <> n.region
        or o.city <> n.city
        or o.manage_org_no <> n.manage_org_no
        or o.route <> n.route
        or o.zjuapmodal <> n.zjuapmodal
        or o.apps <> n.apps
        or o.modify_time <> n.modify_time
        or o.comments <> n.comments
        or o.dac <> n.dac
        or o.change_date <> n.change_date
        or o.before_dev_type <> n.before_dev_type
        or o.pick_flag <> n.pick_flag
        or o.pwd_flag <> n.pwd_flag
        or o.lock_id <> n.lock_id
        or o.lock_date <> n.lock_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_base_info_cl(
            no -- 设备号
            ,ip -- 设备IP地址
            ,org_no -- 所属机构（组织机构/管理机构）
            ,away_flag -- 离行在行标志 1：在行；2：离行
            ,dev_catalog -- 设备类型
            ,dev_vendor -- 设备品牌
            ,dev_type -- 设备型号
            ,work_type -- 经营方式 1—自营  2—联营
            ,status -- （该字段禁止使用）设备状态 1—正常  2—停机
            ,dev_service -- 设备维护商
            ,terminal_no -- 终端号
            ,serial -- 设备序列号 :厂商出厂的序列号
            ,address -- 设备地址
            ,buy_date -- 设备购买日期 yyyy-mm-dd
            ,install_date -- 设备安装日期 yyyy-mm-dd
            ,start_date -- 设备启用日期 yyyy-mm-dd
            ,stop_date -- 设备停用日期 yyyy-mm-dd
            ,open_time -- 每日开机时间 HH:mm:ss
            ,close_time -- 每日关机时间 HH:mm:ss
            ,expire_date -- 保修到期日期 yyyy-mm-dd
            ,patrol_period -- 设备巡检周期
            ,area_no -- 区域编号
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,cashbox_limit -- 钱箱报警金额
            ,os -- 操作系统
            ,atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
            ,anti_virus_soft -- 防病毒软件
            ,sp -- 厂商sp类型
            ,virtual_teller_no -- 虚拟柜员号
            ,care_level -- 设备关注程度 1-重点 2-中等 3-一般
            ,last_pm_date -- 上次巡检日期
            ,expire_pm_date -- 巡检到期日期
            ,locate_no -- 地理位置
            ,note1 -- 备用1:设备营运状态 1启用 2停机
            ,note2 -- 备用2:有无盲道 0-无 1-有，默认0
            ,note3 -- 备用3:邮政编码
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,carrier -- 运营商
            ,money_org -- 加钞机构
            ,dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
            ,environment -- 周边环境
            ,address_code -- 地点代码
            ,cash_type -- 非现金标志: 1、现金；2、非现金
            ,setup_type -- 安装方式:0、大堂；1、穿墙
            ,net_type -- 有线无线标志:C：cable有线 W：wireless无线
            ,operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
            ,registration_status -- 注册状态:0：未注册 1：注册
            ,comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
            ,zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
            ,dek_encoded -- MAK密钥
            ,atmp_area -- p端区域码
            ,selfbanktype -- 自助银行类型
            ,arm_type -- 
            ,pref_no -- 所属地区
            ,country_no -- 所属区划代码
            ,postcode -- 邮政编码
            ,contact -- 联接方式
            ,acpt_ins_id_cd -- 内卡收单机构代码
            ,invstr_ins_id_cd -- 设备投资方代码
            ,maintn_ins_id_cd -- 运行维护方代码
            ,term_publicize_chnl -- 终端渠道宣传
            ,socket -- 终端通讯方式
            ,frn_acpt_tp -- 外卡功能
            ,scan_code -- 扫码功能
            ,magn_read_in -- 磁条卡读取功能
            ,no_card -- 无卡支付功能
            ,cont_ic_in -- 接触式IC卡读取功能
            ,contless_ic_in -- 非接触式IC卡读取功能
            ,term_tran_fun -- 终端业务功能（存款取款转账等）
            ,last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
            ,is_export -- 是否已导出字段：0：未导出，1：已导出
            ,deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
            ,deploy_area_name -- 部署区域具体名称
            ,terminal_status -- 终端状态 2-注销 1-启用
            ,account_org_no -- 账务机构号
            ,self_bank_no -- 自助银行号，离行设备设置该字段
            ,dev_log_path -- 日志路径
            ,trans_rate -- 文件传输速度上限
            ,comm_cst_no -- 村经济合作社客户号
            ,term_account_no -- 终端账户账号
            ,management_name -- 管理员名称
            ,account_type -- 帐户类型
            ,card_flag -- 卡折标志
            ,check_org -- 核算机构
            ,tradingvolume -- 业务量目标值
            ,encryptmode -- 终端数据加密模式
            ,cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
            ,region -- 省
            ,city -- 市
            ,manage_org_no -- 管理机构号
            ,route -- 清机加钞线路
            ,zjuapmodal -- zjuap模式
            ,apps -- 选择关闭的功能
            ,modify_time -- 上次修改日期（YYYY-MM-DD）
            ,comments -- 取款虚拟柜员号
            ,dac -- 存款虚拟柜员号
            ,change_date -- 自助设备更换日期（YYYY-MM-DD）
            ,before_dev_type -- 更换前型号
            ,pick_flag -- 是否支持非接
            ,pwd_flag -- 是否支持国密
            ,lock_id -- 电子密码锁锁具编号
            ,lock_date -- 开锁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_base_info_op(
            no -- 设备号
            ,ip -- 设备IP地址
            ,org_no -- 所属机构（组织机构/管理机构）
            ,away_flag -- 离行在行标志 1：在行；2：离行
            ,dev_catalog -- 设备类型
            ,dev_vendor -- 设备品牌
            ,dev_type -- 设备型号
            ,work_type -- 经营方式 1—自营  2—联营
            ,status -- （该字段禁止使用）设备状态 1—正常  2—停机
            ,dev_service -- 设备维护商
            ,terminal_no -- 终端号
            ,serial -- 设备序列号 :厂商出厂的序列号
            ,address -- 设备地址
            ,buy_date -- 设备购买日期 yyyy-mm-dd
            ,install_date -- 设备安装日期 yyyy-mm-dd
            ,start_date -- 设备启用日期 yyyy-mm-dd
            ,stop_date -- 设备停用日期 yyyy-mm-dd
            ,open_time -- 每日开机时间 HH:mm:ss
            ,close_time -- 每日关机时间 HH:mm:ss
            ,expire_date -- 保修到期日期 yyyy-mm-dd
            ,patrol_period -- 设备巡检周期
            ,area_no -- 区域编号
            ,x -- 横坐标（经度）
            ,y -- 纵坐标（纬度）
            ,cashbox_limit -- 钱箱报警金额
            ,os -- 操作系统
            ,atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
            ,anti_virus_soft -- 防病毒软件
            ,sp -- 厂商sp类型
            ,virtual_teller_no -- 虚拟柜员号
            ,care_level -- 设备关注程度 1-重点 2-中等 3-一般
            ,last_pm_date -- 上次巡检日期
            ,expire_pm_date -- 巡检到期日期
            ,locate_no -- 地理位置
            ,note1 -- 备用1:设备营运状态 1启用 2停机
            ,note2 -- 备用2:有无盲道 0-无 1-有，默认0
            ,note3 -- 备用3:邮政编码
            ,note4 -- 备用4
            ,note5 -- 备用5
            ,carrier -- 运营商
            ,money_org -- 加钞机构
            ,dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
            ,environment -- 周边环境
            ,address_code -- 地点代码
            ,cash_type -- 非现金标志: 1、现金；2、非现金
            ,setup_type -- 安装方式:0、大堂；1、穿墙
            ,net_type -- 有线无线标志:C：cable有线 W：wireless无线
            ,operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
            ,registration_status -- 注册状态:0：未注册 1：注册
            ,comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
            ,zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
            ,dek_encoded -- MAK密钥
            ,atmp_area -- p端区域码
            ,selfbanktype -- 自助银行类型
            ,arm_type -- 
            ,pref_no -- 所属地区
            ,country_no -- 所属区划代码
            ,postcode -- 邮政编码
            ,contact -- 联接方式
            ,acpt_ins_id_cd -- 内卡收单机构代码
            ,invstr_ins_id_cd -- 设备投资方代码
            ,maintn_ins_id_cd -- 运行维护方代码
            ,term_publicize_chnl -- 终端渠道宣传
            ,socket -- 终端通讯方式
            ,frn_acpt_tp -- 外卡功能
            ,scan_code -- 扫码功能
            ,magn_read_in -- 磁条卡读取功能
            ,no_card -- 无卡支付功能
            ,cont_ic_in -- 接触式IC卡读取功能
            ,contless_ic_in -- 非接触式IC卡读取功能
            ,term_tran_fun -- 终端业务功能（存款取款转账等）
            ,last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
            ,is_export -- 是否已导出字段：0：未导出，1：已导出
            ,deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
            ,deploy_area_name -- 部署区域具体名称
            ,terminal_status -- 终端状态 2-注销 1-启用
            ,account_org_no -- 账务机构号
            ,self_bank_no -- 自助银行号，离行设备设置该字段
            ,dev_log_path -- 日志路径
            ,trans_rate -- 文件传输速度上限
            ,comm_cst_no -- 村经济合作社客户号
            ,term_account_no -- 终端账户账号
            ,management_name -- 管理员名称
            ,account_type -- 帐户类型
            ,card_flag -- 卡折标志
            ,check_org -- 核算机构
            ,tradingvolume -- 业务量目标值
            ,encryptmode -- 终端数据加密模式
            ,cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
            ,region -- 省
            ,city -- 市
            ,manage_org_no -- 管理机构号
            ,route -- 清机加钞线路
            ,zjuapmodal -- zjuap模式
            ,apps -- 选择关闭的功能
            ,modify_time -- 上次修改日期（YYYY-MM-DD）
            ,comments -- 取款虚拟柜员号
            ,dac -- 存款虚拟柜员号
            ,change_date -- 自助设备更换日期（YYYY-MM-DD）
            ,before_dev_type -- 更换前型号
            ,pick_flag -- 是否支持非接
            ,pwd_flag -- 是否支持国密
            ,lock_id -- 电子密码锁锁具编号
            ,lock_date -- 开锁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.no -- 设备号
    ,o.ip -- 设备IP地址
    ,o.org_no -- 所属机构（组织机构/管理机构）
    ,o.away_flag -- 离行在行标志 1：在行；2：离行
    ,o.dev_catalog -- 设备类型
    ,o.dev_vendor -- 设备品牌
    ,o.dev_type -- 设备型号
    ,o.work_type -- 经营方式 1—自营  2—联营
    ,o.status -- （该字段禁止使用）设备状态 1—正常  2—停机
    ,o.dev_service -- 设备维护商
    ,o.terminal_no -- 终端号
    ,o.serial -- 设备序列号 :厂商出厂的序列号
    ,o.address -- 设备地址
    ,o.buy_date -- 设备购买日期 yyyy-mm-dd
    ,o.install_date -- 设备安装日期 yyyy-mm-dd
    ,o.start_date -- 设备启用日期 yyyy-mm-dd
    ,o.stop_date -- 设备停用日期 yyyy-mm-dd
    ,o.open_time -- 每日开机时间 HH:mm:ss
    ,o.close_time -- 每日关机时间 HH:mm:ss
    ,o.expire_date -- 保修到期日期 yyyy-mm-dd
    ,o.patrol_period -- 设备巡检周期
    ,o.area_no -- 区域编号
    ,o.x -- 横坐标（经度）
    ,o.y -- 纵坐标（纬度）
    ,o.cashbox_limit -- 钱箱报警金额
    ,o.os -- 操作系统
    ,o.atmc_soft -- atmc软件 1:wsap ;2:WSAPPlus ;3:ZJUAP;9:其他ATMC
    ,o.anti_virus_soft -- 防病毒软件
    ,o.sp -- 厂商sp类型
    ,o.virtual_teller_no -- 虚拟柜员号
    ,o.care_level -- 设备关注程度 1-重点 2-中等 3-一般
    ,o.last_pm_date -- 上次巡检日期
    ,o.expire_pm_date -- 巡检到期日期
    ,o.locate_no -- 地理位置
    ,o.note1 -- 备用1:设备营运状态 1启用 2停机
    ,o.note2 -- 备用2:有无盲道 0-无 1-有，默认0
    ,o.note3 -- 备用3:邮政编码
    ,o.note4 -- 备用4
    ,o.note5 -- 备用5
    ,o.carrier -- 运营商
    ,o.money_org -- 加钞机构
    ,o.dev_status -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
    ,o.environment -- 周边环境
    ,o.address_code -- 地点代码
    ,o.cash_type -- 非现金标志: 1、现金；2、非现金
    ,o.setup_type -- 安装方式:0、大堂；1、穿墙
    ,o.net_type -- 有线无线标志:C：cable有线 W：wireless无线
    ,o.operate_status -- （设备停机功能使用）运营状态:1： 启用 2：停机
    ,o.registration_status -- 注册状态:0：未注册 1：注册
    ,o.comm_packet -- 通讯每包传输大小:有线设备初始8000无线设备初始256
    ,o.zip_type -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
    ,o.dek_encoded -- MAK密钥
    ,o.atmp_area -- p端区域码
    ,o.selfbanktype -- 自助银行类型
    ,o.arm_type -- 
    ,o.pref_no -- 所属地区
    ,o.country_no -- 所属区划代码
    ,o.postcode -- 邮政编码
    ,o.contact -- 联接方式
    ,o.acpt_ins_id_cd -- 内卡收单机构代码
    ,o.invstr_ins_id_cd -- 设备投资方代码
    ,o.maintn_ins_id_cd -- 运行维护方代码
    ,o.term_publicize_chnl -- 终端渠道宣传
    ,o.socket -- 终端通讯方式
    ,o.frn_acpt_tp -- 外卡功能
    ,o.scan_code -- 扫码功能
    ,o.magn_read_in -- 磁条卡读取功能
    ,o.no_card -- 无卡支付功能
    ,o.cont_ic_in -- 接触式IC卡读取功能
    ,o.contless_ic_in -- 非接触式IC卡读取功能
    ,o.term_tran_fun -- 终端业务功能（存款取款转账等）
    ,o.last_statue -- 设备信息最后一次状态：“I”：新增，“U”：修改，“D”：删除
    ,o.is_export -- 是否已导出字段：0：未导出，1：已导出
    ,o.deploy_area_no -- 部署区域特征  01-商圈，02-居民社区，03-企业园区，04-车站机场，05-学校，06-医院，07-景区，08-自定义区域
    ,o.deploy_area_name -- 部署区域具体名称
    ,o.terminal_status -- 终端状态 2-注销 1-启用
    ,o.account_org_no -- 账务机构号
    ,o.self_bank_no -- 自助银行号，离行设备设置该字段
    ,o.dev_log_path -- 日志路径
    ,o.trans_rate -- 文件传输速度上限
    ,o.comm_cst_no -- 村经济合作社客户号
    ,o.term_account_no -- 终端账户账号
    ,o.management_name -- 管理员名称
    ,o.account_type -- 帐户类型
    ,o.card_flag -- 卡折标志
    ,o.check_org -- 核算机构
    ,o.tradingvolume -- 业务量目标值
    ,o.encryptmode -- 终端数据加密模式
    ,o.cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
    ,o.region -- 省
    ,o.city -- 市
    ,o.manage_org_no -- 管理机构号
    ,o.route -- 清机加钞线路
    ,o.zjuapmodal -- zjuap模式
    ,o.apps -- 选择关闭的功能
    ,o.modify_time -- 上次修改日期（YYYY-MM-DD）
    ,o.comments -- 取款虚拟柜员号
    ,o.dac -- 存款虚拟柜员号
    ,o.change_date -- 自助设备更换日期（YYYY-MM-DD）
    ,o.before_dev_type -- 更换前型号
    ,o.pick_flag -- 是否支持非接
    ,o.pwd_flag -- 是否支持国密
    ,o.lock_id -- 电子密码锁锁具编号
    ,o.lock_date -- 开锁日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.atms_dev_base_info_bk o
    left join ${iol_schema}.atms_dev_base_info_op n
        on
            o.no = n.no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_base_info_cl d
        on
            o.no = d.no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_dev_base_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_base_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_base_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_base_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_base_info exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_base_info_cl;
alter table ${iol_schema}.atms_dev_base_info exchange partition p_20991231 with table ${iol_schema}.atms_dev_base_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_base_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_base_info_op purge;
drop table ${iol_schema}.atms_dev_base_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_base_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_base_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
