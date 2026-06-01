/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_base_info
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM atms_dev_base_info_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('atms_dev_base_info');
  
  if v_var <> 0 then 
    execute immediate 'alter table atms_dev_base_info drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table atms_dev_base_info add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.atms_dev_base_info(
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
            no -- 设备号
            ,ip -- 设备IP地址
            ,org_no -- 所属机构（组织机构/管理机构）
            ,to_char(away_flag) -- 离行在行标志 1：在行；2：离行
            ,to_char(dev_catalog) -- 设备类型
            ,to_char(dev_vendor) -- 设备品牌
            ,to_char(dev_type) -- 设备型号
            ,to_char(work_type) -- 经营方式 1—自营  2—联营
            ,to_char(status) -- （该字段禁止使用）设备状态 1—正常  2—停机
            ,to_char(dev_service) -- 设备维护商
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
            ,to_char(patrol_period) -- 设备巡检周期
            ,area_no -- 区域编号
            ,to_char(x) -- 横坐标（经度）
            ,to_char(y) -- 纵坐标（纬度）
            ,cashbox_limit -- 钱箱报警金额
            ,substrb(os,1,5) -- 操作系统
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
            ,to_char(dev_status) -- 设备状态 :1－启用 2－停用 3—审批 4－正常 5－警告 6－故障 7－关机 8－撤销
            ,environment -- 周边环境
            ,address_code -- 地点代码
            ,to_char(cash_type) -- 非现金标志: 1、现金；2、非现金
            ,to_char(setup_type) -- 安装方式:0、大堂；1、穿墙
            ,net_type -- 有线无线标志:C：cable有线 W：wireless无线
            ,to_char(operate_status) -- （设备停机功能使用）运营状态:1： 启用 2：停机
            ,to_char(registration_status) -- 注册状态:0：未注册 1：注册
            ,to_char(comm_packet) -- 通讯每包传输大小:有线设备初始8000无线设备初始256
            ,to_char(zip_type) -- 通讯传输压缩方式:0：不压缩;1：未使用；2：zip压缩；3：gzip压缩;有线设备初始:0 无线设备初始:3
            ,dek_encoded -- MAK密钥
            ,atmp_area -- p端区域码
            ,to_char(selfbanktype) -- 自助银行类型
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
            ,' ' as account_org_no -- 账务机构号
            ,' ' as self_bank_no -- 自助银行号，离行设备设置该字段
            ,' ' as dev_log_path -- 日志路径
            ,' ' as trans_rate -- 文件传输速度上限
            ,' ' as comm_cst_no -- 村经济合作社客户号
            ,' ' as term_account_no -- 终端账户账号
            ,' ' as management_name -- 管理员名称
            ,0 as account_type -- 帐户类型
            ,0 as card_flag -- 卡折标志
            ,' ' as check_org -- 核算机构
            ,0 as tradingvolume -- 业务量目标值
            ,' ' as encryptmode -- 终端数据加密模式
            ,0 as cycle_flag -- 是否开通循环（CRS设备）：0-未开通，1-开通
            ,' ' as region -- 省
            ,' ' as city -- 市
            ,' ' as manage_org_no -- 管理机构号
            ,' ' as route -- 清机加钞线路
            ,' ' as zjuapmodal -- zjuap模式
            ,' ' as apps -- 选择关闭的功能
            ,' ' as modify_time -- 上次修改日期（YYYY-MM-DD）
            ,' ' as comments -- 取款虚拟柜员号
            ,' ' as dac -- 存款虚拟柜员号
            ,' ' as change_date -- 自助设备更换日期（YYYY-MM-DD）
            ,' ' as before_dev_type -- 更换前型号
            ,' ' as pick_flag -- 是否支持非接
            ,' ' as pwd_flag -- 是否支持国密
            ,' ' as lock_id -- 电子密码锁锁具编号
            ,' ' as lock_date -- 开锁日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_dev_base_info_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
